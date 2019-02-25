class GameMobileAdminController < ApplicationController
  before_action :authenticate_game!, :authenticate_admin!, :set_vars, except: [:replay, :new, :create, :ended]
  before_action :set_turn, only: [:turn, :play, :rate, :rated, :rating]
  layout 'game_mobile'
    
  def new
  end
    
  def create
    @game = Game.where(password: params[:password], active: true).first
    if @game
      sign_in(@game)
      @admin = Admin.where(id: @game.admin_id, email: params[:admin][:email].downcase).first
      if @admin && @admin.valid_password?(params[:admin][:password])
        sign_in(@admin)
        redirect_to gma_new_avatar_path
      else
        flash[:danger] = "Unbekannte E-Mail / Password Kombination"
        redirect_to root_path
      end
    else
      flash[:danger] = "Konnte kein passende Siel finden"
      redirect_to root_path
    end
  end
    
  def new_avatar
  end
    
  def create_avatar
    @admin.update(avatar: params[:admin][:avatar])
    redirect_to gma_new_avatar_path
  end
    
  def new_turn
    @turn = @game.turns.find_by(admin_id: @admin.id)
    if @turn
      redirect_to gma_intro_path
    end
  end
    
  def create_turn
    @word = Word.all.sample(5).first
    @turn = Turn.new(play: params[:turn][:play], admin_id: @admin.id, game_id: @game.id, word_id: @word.id, played: false)
    if @turn.save
      redirect_to gma_intro_path
    else
      redirect_to gma_new_turn_path
    end
  end
    
  def intro
  end
    
  def wait
    if @game.state == 'intro' || @game.state == 'replay'
      @game.update(state: 'wait')
    end
  end
    
  def choose
    if @game.state == 'wait' || @game.state == 'rating'
      @game.update(state: 'choose')
    end
  end
    
  def turn
    if @game.state == 'choose'
      @game.update(state: 'turn')
    end
  end
    
  def play
    if @game.state == 'turn'
      @game.update(state: 'play')
    end
  end
    
  def rate
    if @game.state == 'play'
      @game.update(state: 'rate')
    end
    if @turn.ratings.find_by(admin_id: @admin.id)
      redirect_to gma_rated_path
    elsif @admin == @cur_user
      redirect_to gma_rated_path
    end
  end
    
  def rated
    @ratings_count = @turn.ratings.count
    @player_count = @game.turns.count-1
  end
    
  def rating
    if @game.state == 'rate'
      @game.update(state: 'rating')
    end
  end
    
  def bestlist
  end
    
  def ended
    if @game = current_game
      @game.update(state: 'ended')
      sign_out(@game)
    end
    redirect_to root_path
  end
    
  def replay
    if @game = current_game
      @admin = @game.admin
      @game1 = Game.where(password: @game.password, active: true).first
      @game.update(state: 'replay')
      sign_out(@game)
      if !@game1
        @game1 = @admin.games.create(team_id: @game.team_id, state: 'wait', password: @game.password, active: true)
      end
      sign_in(@game1)
      redirect_to gma_wait_path
    else
      redirect_to root_path
    end
  end
    
  private
    def set_vars
      @admin = current_admin
      @game = current_game
      @team = Team.find(@game.team_id)
      @state = @game.state
    end
    
    def set_turn
      @turn = Turn.find_by(id: @game.current_turn)
      @cur_user = @turn.findUser
    end
    
    def turn_params
      params.require(:turn).permit[:play]
    end
end

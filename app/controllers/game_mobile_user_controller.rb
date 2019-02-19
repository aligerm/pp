class GameMobileUserController < ApplicationController
  before_action :authenticate_user!, :authenticate_game!, :set_vars, except: [:replay, :new, :create, :ended]
  before_action :set_turn, only: [:turn, :play, :rate, :rated, :rating]
  layout 'game_mobile'
    
  def new
  end
    
  def create
    @game = Game.where(password: params[:password], active: true).first
    if @game
      sign_in(@game)
      @admin = Admin.find(@game.admin_id)
      @user = User.find_by(email: params[:user][:email])
      if @user && @user.admin == @admin
        sign_in(@user)
        redirect_to gmu_new_turn_path
      else
        @user = @admin.users.create(email: params[:user][:email])
        sign_in(@user)
        redirect_to gmu_new_name_path
      end
    else
      flash[:danger] = 'Konnte kein passendes Spiel finden!'
      redirect_to root_path
    end
  end
  def new_name
  end
    
  def create_name
    @user.update(user_params)
    redirect_to gmu_new_company_path
  end
    
  def new_company
  end
    
  def create_company
    @user.update(user_params)
    redirect_to gmu_new_avatar_path
  end
    
  def new_avatar
  end
    
  def create_avatar
    @user.update(user_params)
    redirect_to gmu_new_avatar_path
  end
    
  def new_turn
    @turn = @game.turns.find_by(user_id: @user.id)
    if @turn
      redirect_to gmu_wait_path
    end
  end
    
  def create_turn
    @word = Word.all.sample(5).first
    @turn = Turn.new(user_id: @user.id, game_id: @game.id, word_id: @word.id, play: params[:turn][:play], played: false)
    if @turn.save
      redirect_to gmu_wait_path
    else
      redirect_to gmu_new_turn_path
    end
  end
    
  def wait
  end

  def choose
  end
    
  def turn
  end
    
  def play
  end
    
  def rate
    if @user == @cur_user || @turn.ratings.find_by(user_id: @user.id)
        redirect_to gmu_rated_path
    end
  end
    
  def rated
  end
    
  def rating
  end
    
  def bestlist
  end
    
  def replay
    if @game = current_game
      @game1 = Game.where(password: @game.password, active: true).first
      sign_out(@game)
      sign_in(@game1)
      redirect_to gmu_new_turn_path
    else
      redirect_to root_path
    end
  end
    
  def ended
    if @game = current_game
      sign_out(@game)
    end
    if @user = current_user
      sign_out(@user)
    end
    redirect_to root_path
  end
    
  private
    def set_vars
      @user = current_user
      @game = current_game
      @state = @game.state
    end
    
    def set_turn
      @turn = Turn.find_by(id: @game.current_turn)
      @cur_user = @turn.findUser
    end
    
    def user_params
      params.require(:user).permit(:avatar, :company, :fname, :lname)
    end
end

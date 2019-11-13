class BackofficeController < ApplicationController
  before_action :if_root
  before_action :require_root, :set_root
  before_action :set_admin, only: [:admin, :activate_admin, :destroy_admin]
  before_action :if_basket, only: [:word_baskets]
  before_action :set_basket, only: [:words]
  layout 'backoffice'
      
  #GET backoffice_admins
  def index
    @admins = Admin.where(activated: false).all
  end

  def admins
    @admins = Admin.where(activated: true).all
  end
    
  def admin
  end
    
  def activate_admin
    if @admin.update(activated: true)
      flash[:success] = 'Admin aktiviert'
      @admin.send_reset_password_instructions
    else
      flash[:danger] = 'FEHLER!'
    end
    redirect_to backoffice_admin_path(@admin)
  end
  def destroy_admin
    if @admin.destroy
      flash[:success] = 'Admin deactiviert'
      redirect_to backoffice_path
    else
      flash[:danger] = 'FEHLER!'
      redirect_to backoffice_admin_path(@admin)
    end
  end
    
  #GET backoffice_words
  def word_baskets
    @baskets = CatchwordsBasket.all
  end

  def words
    @words = @basket.words.all
  end
    
  private
    def if_root
      if Root.count == 0
        Root.create(username: 'root', password: 'ratte')
      end
    end
    def set_root
      @root = current_root
    end
    def set_admin
      @admin = Admin.find(params[:admin_id])
    end
    def set_basket
      @basket = CatchwordsBasket.find(params[:basket_id])
    end
      
    def if_basket
      if CatchwordsBasket.count == 0
        CatchwordsBasket.create(name: 'PetersWords')
      end
    end

    def admin_params
      params.require(:admin).permit(:fname, :lname, :company_name, :email, :password, :password_confirm)
    end
end

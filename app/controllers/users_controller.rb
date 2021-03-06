class UsersController < ApplicationController
  before_action :authenticate_admin!, :set_vars
  
  def destroy
    if @user.destroy
      flash[:success] = 'Spieler erfolgreich gelöscht!'
      redirect_to dash_admin_users_path
    else
      flash[:danger] = 'Konnte Spieler nicht löschen!'
      redirect_to dash_admin_users_path
    end
  end
    
  private
    def set_vars
      @admin = current_admin
      @user = User.find(params[:user_id])
    end
end

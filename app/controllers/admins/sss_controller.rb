class Admins::SssController < ApplicationController

   

    protected
    def after_sign_in_path_for(resource)
      dash_admin_path
    end

    private 
    def admin_params
      params.require(:admin).permit(:id ,:email , :password)
    end
end
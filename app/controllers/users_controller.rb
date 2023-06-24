class UsersController < ApplicationController
  include ApplicationHelper

  def index
    @users = User.all
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    
    redirect_to users_path, :notice => 'User successfully deleted'  
  end
end

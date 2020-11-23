class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end
  def index
    @users = User.all
    @user_name = @users.map { |user| @user_name = user.name }
    @all_users = @user_name.to_json
    render json: @all_users
  end
end

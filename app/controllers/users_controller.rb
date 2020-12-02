class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end
  def index
    users_hash = User.all.map { |user| {id: user.id, name: user.name } }
    render json: users_hash.to_json
  end
end

class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  def show
    if user_signed_in? 
      @user = User.find(current_user.id)
    else
      redirect_to(new_user_session)
    end
  end
  
  def index
    users_hash = User.all.map { |user| {id: user.id, name: user.name } }
    render json: users_hash.to_json
  end
end

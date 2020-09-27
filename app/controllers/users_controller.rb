class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    #@re1 = Reserve.find(1)
    #@re1_start = @re1.reservation_start_time
    #@time = @re1_start.hour
  end
end

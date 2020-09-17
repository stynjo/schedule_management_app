class ReservesController < ApplicationController
  protect_from_forgery with: :null_session
    def create
      @reserve = Reserve.new(resereve_params)
      @reserve.save
      flash[:success] ='予約登録を完了しました'
      head :no_content
    end
  
    
    private
      def resereve_params
        params.require(:reserve).permit(:number_of_people :reservation_start_time, :reservation_end_time)
      end
end

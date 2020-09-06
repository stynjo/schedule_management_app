class ReservesController < ApplicationController
    def create
      @reserve = Reserve.new(resereve_params)
      @reserve.save
      flash[:success] ='予約登録を完了しました'
      head :no_content
    end
    
    private
      def resereve_params
        params.permit(:reservation_date, :reservation_start_time, :reservation_end_time)
      end
end

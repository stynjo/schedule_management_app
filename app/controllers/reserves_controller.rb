class ReservesController < ApplicationController
    def create
      @reserve = Reserve.new(resereve_params)
      @resereve.save
      flash[:success] ='予約登録を完了しました'
      head :no_content
    end
    
    private
      def resereve_params
        params.require(:reserve).permit(:reservation_date, :number_of_people, :reservation_start_time, :reservation_end_time)
      end
end

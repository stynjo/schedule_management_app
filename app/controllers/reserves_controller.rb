class ReservesController < ApplicationController
  protect_from_forgery with: :null_session
    def create
      @reserve = Reserve.new(resereve_params)
      if @reserve.save
        render json: @resereve, status: :created
      else
        render json: @reserve, status: :unprocessable_entity
      end
    end
    
    def index
      @reservation_date_string = params[:reservationDate]
      @date_value = @reservation_date_string.in_time_zone
      
      #取得したい予約を取ってくる
      @reservation_date = Reserve.where(reservation_date: @date_value.all_day)
      # Hash#valuesはkeyの追加順で生成されるので、事前にhashを作ってしまう
      reserve_time_hash = %w[18 19 20 21 22 23].map { |i| [ i.to_s, 0 ] }.to_h
      
      @reservation_date.each do |reserve|
      (reserve.reservation_start_time.hour..reserve.reservation_end_time.hour).each do |hour|
        reserve_time_hash[hour.to_s] += reserve.number_of_people
      end
        @reserve_times = reserve_time_hash.values.to_json
      end
       render json: @reserve_times
    end
    
    
    def list
      @reservation_date_string = params[:reservationDate]
      @date_value = @reservation_date_string.in_time_zone
      reserve_lists = []
      
      #取得したい予約を取ってくる
      @reservation_date = Reserve.where(reservation_date: @date_value.all_day)
      @reservation_date.each do |reserve|
        reserve_lists.push(reserve.to_json)
      end
      render json: reserve_lists
    end
    
    private
      def resereve_params
        params.require(:reserve).permit(:number_of_people, :reservation_start_time, :reservation_end_time, :reservation_date, :reserve_name)
      end
      
end

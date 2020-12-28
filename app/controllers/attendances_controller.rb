class AttendancesController < ApplicationController
  
  def show
  end
  
  # 登録API
  def create
    @attendances = Attendance.new(attendance_params)
    @attendances.save
    head :no_content
  end
  
  # 日付に応じた勤怠一覧API
  def date
    @date = params[:date]
    @change_date = @date.in_time_zone
    @attendance_date = Attendance.where(started_at: @change_date.all_day)
    @attendance_date_json = @attendance_date.to_json
    render json: @attendance_date_json
  end
  
  def import
   response = Attendance.import(params[:file])
   if response == true
      render json: response, status: :created
   elsif response == :unprocessable_entity
     render json: response, status: :unprocessable_entity
   end
  end
  
  def update
    #TODO
    #ルーティング組み直し attendances/:user_id (仮)
    #@attendance = params[:user_id] 
    byebug
  end
  
  def attendance_params
    params.require(:attendance).permit(:user_id, :started_at, :finished_at)
  end
end

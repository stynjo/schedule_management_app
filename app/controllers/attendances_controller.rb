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
    @attendance_date = params[:date]
    byebug
  end
  
  
  def attendance_params
    params.require(:attendance).permit(:user_id, :started_at, :finished_at)
  end
end

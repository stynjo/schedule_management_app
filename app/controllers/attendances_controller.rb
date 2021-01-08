class AttendancesController < ApplicationController
  
  def show
  end
  
  def index
    @reservation_date_string = params[:reservationDate]
    @date_value = @reservation_date_string.in_time_zone
      #取得したい勤怠情報を取ってくる
    @attendance_date = Attendance.where(started_at: @date_value.all_day)
      # Hash#valuesはkeyの追加順で生成されるので、事前にhashを作ってしまう
    time_hash = %w[18 19 20 21 22 23].map { |i| [ i.to_s, 0 ] }.to_h
  
    @attendance_date.each do |att|
      (att.started_at.hour..att.finished_at.hour).each do |hour|
        time_hash[hour.to_s] += 1
      end
        @number_of_employees = time_hash.values.to_json
    end
      render json: @number_of_employees 
  end
  
  # 登録API
  def create
    @attendances = Attendance.new(attendance_params)
    if  @attendances.save
      render json: @attendance, status: :created
    elsif 
      render json: @attendance, status: :unprocessable_entity
    end
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
  
  def destroy
    @attendance = Attendance.find(params[:attendanceId])
    binding.pry
    if @attendance.destroy
      head :no_content
    else
      render json: @attendance.errors, status: :unprocessable_entity
    end
  end
  
  def update
    attendance = Attendance.find_by(id: params[:attendance][:user_id])
    if attendance.update_attributes(attendance_params)
      render json: attendance, status: :created
    elsif 
      render json: attendance, status: :unprocessable_entity
    end
  end
  
  def attendance_params
    params.require(:attendance).permit(:user_id, :started_at, :finished_at)
  end
end

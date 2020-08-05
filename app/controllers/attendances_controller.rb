class AttendancesController < ApplicationController
  
  def index
    @first_day = Date.current.beginning_of_month
    @last_day = @first_day.end_of_month
  end
  
end

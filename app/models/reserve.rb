class Reserve < ApplicationRecord
    validate :reservation_time
    

  def reservation_time
    errors.add(:reservation_start_time, "予約時間を正しく入力してください。") if reservation_start_time > reservation_end_time 
  end
  
  #def resrve_create_is_invalid_without_number_of_people
    #errors.add(:, "が必要です") if .blank? && .present?
 # end
end

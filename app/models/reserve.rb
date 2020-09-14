class Reserve < ApplicationRecord
    validate :reservation_time
    

  def reservation_time
    errors.add(:reservation_start_time, "予約時間を正しく入力してください。") if reservation_start_time > reservation_end_time 
  end
end

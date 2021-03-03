class Reserve < ApplicationRecord
  
  validates :number_of_people, presence: true, numericality: {greater_than: 1,less_than: 31}
  validates :reserve_name, presence: true, length: { maximum: 30 }

  validate :validate_reservation_times

  private

  def validate_reservation_times
    if invalid_time?(reservation_start_time) || invalid_time?(reservation_end_time)
      errors.add(:base, "入力が正しくありません")
      return
    end

    errors.add(:base, "予約開始時間より早い終了時間は無効です") if reservation_start_time > reservation_end_time
  end

  def invalid_time?(time)
    time.blank? || time.strftime("%T") == "00:00:00"
  end
end
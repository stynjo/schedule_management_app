class Attendance < ApplicationRecord
  belongs_to :user
  
  #validates :worked_on, presence: true
  #validates :started_at, presence: true
  
  #出勤時間が存在しないと退勤時間葉は無効
#  validates :finished_at_is_invalid_without_a_started_at
  
 # def finished_at_is_invalid_without_a_started_at
  #  errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
 # end
end

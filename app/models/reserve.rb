class Reserve < ApplicationRecord
  # 予約開始時間、または終了時間が存在しない場合入力は無効
  validate :invalid_without_a_reservation_start_time_or_reservation_end_time
  # 予約開始時間より予約終了時間が早い場合は無効
  validate :reservation_start_time_than_reservation_end_time_fast_if_invalid


  def invalid_without_a_reservation_start_time_or_reservation_end_time
    errors.add("入力が正しくありません") if reservation_start_time.blank? || reservation_end_time.blank?
  end

  def reservation_start_time_than_reservation_end_time_fast_if_invalid
    if reservation_start_time.present? && reservation_end_time.present?
      errors.add("予約開始時間より早い終了時間は無効です") if reservation_start_time > reservation_end_time
    end
  end
end

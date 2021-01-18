class Attendance < ApplicationRecord
  belongs_to :user
  
  # 出勤時間が存在しない場合、退勤時間は無効
  validate :finished_at_is_invalid_without_a_started_at
  # 出勤・退勤時間どちらも存在する時、出勤時間より早い退勤時間は無効
  validate :started_at_than_finished_at_fast_if_invalid

  
  def self.import(file)
    unless file
       raise RangeError, "ERROR!"
    else
      CSV.foreach(file.path, headers: true) do |row|
        # IDが見つかれば、レコードを呼び出し、見つかれなければ、新しく作成
        att = find_by(user_id: row["user_id"], started_at: row["started_at"]) || new
        # CSVからデータを取得し、設定する
        att.attributes = row.to_hash.slice(*updatable_attributes)
        # 保存する
        if  (!att.save)
          return :unprocessable_entity
        end
      end
      return true
    end
  end

  # 更新を許可するカラムを定義
  def self.updatable_attributes
    ["user_id", "started_at", "finished_at"]
  end
  
  
  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end

  def started_at_than_finished_at_fast_if_invalid
    if started_at.present? && finished_at.present?
      started_at_to_dat.to_date
      finished_at_to_date.to_date
      errors.add(:started_at, "より早い退勤時間は無効です") if started_at_to_date > finished_at_to_date
    end
  end
  
end

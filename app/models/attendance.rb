class Attendance < ApplicationRecord
  belongs_to :user
  
  validate :validate_attendance
  
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
  
  
  def validate_attendance
    # 出勤時間、または退勤時間が存在しない場合入力は無効
    if invalid_time?(started_at) || invalid_time?(finished_at)
      errors.add(:base, "入力が正しくありません")
      return
    end
    # 出勤・退勤時間どちらも存在する時、出勤時間より早い退勤時間は無効
     errors.add(:base, "出勤時間より早い退勤時間は無効です") if started_at > finished_at
  end
  
  def invalid_time?(time)
    time.blank? || time.strftime("%T") == "00:00:00"
  end

end

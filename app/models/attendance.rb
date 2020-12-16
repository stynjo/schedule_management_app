class Attendance < ApplicationRecord
  belongs_to :user
  
  def self.import(file)
    unless file
       raise RangeError, "ERROR!"
    else
      CSV.foreach(file.path, headers: true) do |row|
      # IDが見つかれば、レコードを呼び出し、見つかれなければ、新しく作成
        att = find_by(user_id: row["user_id"]) || new
      # CSVからデータを取得し、設定する
        att.attributes = row.to_hash.slice(*updatable_attributes)
      # 保存する
        att.save
      end
    end
  end

  # 更新を許可するカラムを定義
  def self.updatable_attributes
    ["user_id", "started_at", "finished_at"]
  end
  
end

require 'rails_helper'

RSpec.describe Attendance, type: :model do
  describe '異常系テスト' do
    it '出勤時間が存在しない場合入力は無効' do
      attendance = FactoryBot.build(:attendance, started_at: nil)
      attendance.valid?
      expect(attendance.errors[:base]).to include("入力が正しくありません")
    end
    it '退勤時間が存在しない場合入力は無効' do
      attendance = FactoryBot.build(:attendance, finished_at: nil)
      attendance.valid?
      expect(attendance.errors[:base]).to include("入力が正しくありません")
    end
    it '退勤時間が出勤時間より早いと無効であること' do
      attendance = FactoryBot.build(:attendance, started_at: 'Mon, 01 Feb 2021 19:00:00 JST +09:00', finished_at: 'Mon, 01 Feb 2021 18:00:00 JST +09:00')
      attendance.valid?
      expect(attendance.errors[:base]).to include("出勤時間より早い退勤時間は無効です")
    end
  end
end
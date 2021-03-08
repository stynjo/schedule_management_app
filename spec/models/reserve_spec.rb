require 'rails_helper'

RSpec.describe Reserve, type: :model do
  describe '正常系テスト' do
    it '予約名、人数、予約開始時間、予約終了時間がある場合有効である' do
      reserve = FactoryBot.build(:reserve)
      expect(reserve).to be_valid 
    end
  end

  describe '異常系テスト' do
    it '予約名が無い場合無効であること' do
      reserve = FactoryBot.build(:reserve, reserve_name: nil)
      reserve.valid?
      expect(reserve.errors[:reserve_name]).to include("can't be blank")
    end

    it '予約人数の入力が無い場合無効であること' do
      reserve = FactoryBot.build(:reserve, number_of_people: nil)
      reserve.valid?
      expect(reserve.errors[:number_of_people]).to include("can't be blank")
    end

    it '予約人数が1人以下の場合無効であること' do
      reserve = FactoryBot.build(:reserve, number_of_people: 1)
      reserve.valid?
      expect(reserve.errors[:number_of_people]).to include("must be greater than 1")
    end

    it '予約人数が31人以上の場合無効であること' do
      reserve = FactoryBot.build(:reserve, number_of_people: 31)
      reserve.valid?
      expect(reserve.errors[:number_of_people]).to include("must be less than 31")
    end

    it '予約開始時間が存在しない場合は無効であること' do
      reserve = FactoryBot.build(:reserve, reservation_start_time: nil)
      reserve.valid?
      expect(reserve.errors[:base]).to include("入力が正しくありません")
    end
    
    it '予約終了時間が存在しない場合は無効であること' do
      reserve = FactoryBot.build(:reserve, reservation_end_time: nil)
      reserve.valid?
      expect(reserve.errors[:base]).to include("入力が正しくありません")
    end
    it '予約終了時間が予約開始時間より早いと無効であること' do
      reserve = FactoryBot.build(:reserve, reservation_start_time: 'Mon, 01 Feb 2021 19:00:00 JST +09:00', reservation_end_time: 'Mon, 01 Feb 2021 18:00:00 JST +09:00')
      reserve.valid?
      expect(reserve.errors[:base]).to include("予約開始時間より早い終了時間は無効です")
    end
  end
end
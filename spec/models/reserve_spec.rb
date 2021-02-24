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
      expect(reserve.errors[:invalid_without_a_reservation_start_time_or_reservation_end_time]).to include("入力が正しくありません")
    end
  end
  
end
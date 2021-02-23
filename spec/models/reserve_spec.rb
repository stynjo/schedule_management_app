require 'rails_helper'

RSpec.describe Reserve, type: :model do
  describe '正常系テスト' do
    it '予約名、人数、予約開始時間、予約終了時間がある場合有効である' do
      reserve = FactoryBot.build(:reserve)
      expect(reserve).to be_valid 
    end
  end
end
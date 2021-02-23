require 'rails_helper'

RSpec.describe Reserve, type: :model do
  describe '正常系テスト' do
    it '予約名、人数、予約開始時間、予約終了時間がある場合有効である' do
      reserve = Reserve.new(
        reserve_name: 'test',
        number_of_people: 3,
        reservation_start_time: 'Mon, 01 Feb 2021 18:00:00 JST +09:00',
        reservation_end_time: 'Mon, 01 Feb 2021 20:00:00 JST +09:00'
      )
      expect(reserve).to be_valid 
    end
  end
end
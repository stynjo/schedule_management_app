require 'rails_helper'

RSpec.describe "attendance", type: :request do 
  describe "GET/show" do
    let(:user_params) { attributes_for(:user) }
    before do 
      post user_registration_path, params: { user: user_params }
    end
    it "リクエストが成功すること" do
      get '/attendances'
      expect(response).to have_http_status(200)
    end
  end
  
  describe "GET/index", type: :request do
    it "リクエストが成功すること" do
      get '/attendances/index', params: { reservationDate: "2021/3/1"}
      expect(response).to have_http_status(200)
    end
  end
  
  describe "GET/date", type: :request do
    it "リクエストが成功すること" do
      get '/attendances/date/2021-03-01', params: { date: "2021/3/1"}
      expect(response).to have_http_status(200)
    end
  end
  
  describe 'POST /create' do
    context 'パラメータが妥当な場合' do
      let(:user_params) { attributes_for(:user) }
        before do 
          post user_registration_path, params: { user: user_params }
        end
        it '勤怠が登録されること' do
          post '/attendances', params: { attendance: FactoryBot.attributes_for(:attendance) }
          expect(response).to have_http_status(201)
        end
    end
    context 'パラメータが不正な場合' do
      it '勤怠が登録されないこと'do
        expect do
          post '/attendances', params: { attendance: FactoryBot.attributes_for(:attendance, started_at: nil) }
        end.to_not change(Reserve, :count)
      end
    end
  end
  
end
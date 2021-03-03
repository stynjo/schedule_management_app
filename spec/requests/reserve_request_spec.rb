require 'rails_helper'

RSpec.describe "Reserves", type: :request do

  describe "GET /index" do
    it "'リクエストが成功すること'" do
      get '/reserves/index', params: { reservationDate: "2021/3/1" }
      expect(response).to have_http_status(200)
    end
  end
  
  describe "GET /list" do
    it "'リクエストが成功すること'" do
      get '/reserves/date', params: { reservationDate: "2021/3/1" }
      expect(response).to have_http_status(200)
    end
  end
  
  describe 'POST /create' do
    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        post '/reserves', params: { reserve: FactoryBot.attributes_for(:reserve) }
        expect(response).to have_http_status(201)
      end
    end
    context 'パラメータが不正な場合' do
      it 'ユーザーが登録されないこと'do
        expect do
          post '/reserves', params: { reserve: FactoryBot.attributes_for(:reserve, reserve_name: nil) }
        end.to_not change(Reserve, :count)
      end
    end
  end
  
  describe 'DELETE /destroy' do
    context 'パラメータが妥当な場合' do
      it '予約が削除されること' do
        reserve = FactoryBot.create(:reserve)
        delete '/reserves', params: { resereveId:  reserve.id }
        expect(response).to have_http_status(204)
      end
    end
  end
  
end
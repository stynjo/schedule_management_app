require 'rails_helper'

RSpec.describe "attendance", type: :controller do 
  describe "GET/show" do
    user = FactoryBot.create(:user)
      before do
        login_user user
      end
    it "リクエストが成功すること" do
      get '/attendances'
      expect(response).to have_http_status(200)
    end
  end
end
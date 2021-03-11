require 'rails_helper'

RSpec.describe "attendance", type: :request do 
  describe "GET/show" do
    let(:user_params) { attributes_for(:user) }
    before do 
      post user_session_path, params: { user: user_params }
    end
    it "リクエストが成功すること" do
      get '/attendances'
      expect(response).to have_http_status(200)
    end
  end
end
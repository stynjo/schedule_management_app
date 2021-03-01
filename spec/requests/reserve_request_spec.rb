require 'rails_helper'

RSpec.describe "Reserves", type: :request do

  describe "GET /index" do
    it "render idex" do
    get '/reserves/index', params: { reservationDate: "2021/3/1" }
    expect(response).to have_http_status(200)
    end
  end
end
require 'rails_helper'

RSpec.describe "UserAuthentications", type: :request do

  describe 'POST #create' do
    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        post user_registration_path, params: { user: FactoryBot.attributes_for(:user) }
        expect(response.status).to eq 302
      end

      it 'createが成功すること' do
         post user_registration_path, params: { user: FactoryBot.attributes_for(:user) }
         expect(response.status).to eq 302
      end

    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        post user_registration_path, params: { user: FactoryBot.attributes_for(:user, email: nil) }
        expect(response.status).to eq 200
      end


      it 'createが失敗すること' do
        expect do
          post user_registration_path, params: { user: FactoryBot.attributes_for(:user, email: nil) }
        end.to_not change(User, :count)
      end

    end
  end
end
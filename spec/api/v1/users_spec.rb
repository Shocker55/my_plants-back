require 'rails_helper'

describe Api::V1::UsersController, type: :request do
  let(:headers) { { CONTENT_TYPE: 'application/json', Authorization: "Bearer #{ENV['TOKEN']}" } }

  describe 'GET /users' do
    it '全てのユーザーを取得する' do
      get api_v1_users_path
      expect(response.status).to eq(200)
    end
  end

  describe 'GET /users/{id}' do
    let(:user) { FactoryBot.create(:user) }

    it "特定のユーザーを取得する" do
      get api_v1_user_path(user)
      expect(response.status).to eq(200)
    end
  end

  describe 'GET /user/{id}/likes' do
  end
  describe 'GET /user/{id}/attend' do
  end
  describe 'GET /user/record_bookmarks' do
  end
  describe 'GET /user/event_bookmarks' do
  end
  describe 'GET /user/widget' do
  end
end

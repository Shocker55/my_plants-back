require 'rails_helper'

describe Api::V1::UsersController, type: :request do
  include AuthenticationHelper
  let(:headers) { { CONTENT_TYPE: 'application/json', Authorization: "Bearer #{ENV['TOKEN']}" } }
  let(:user) { FactoryBot.create(:user) }

  describe 'GET /users' do
    it '全てのユーザーを取得する' do
      get api_v1_users_path
      expect(response.status).to eq(200)
    end
  end

  describe 'GET /users/{id}' do
    it "特定のユーザーを取得する" do
      get api_v1_user_path(user)
      expect(response.status).to eq(200)
    end
  end

  describe 'GET /user/{id}/likes' do
    let(:records) { FactoryBot.create_list(:record, 5, user:) }
    let!(:recod_likes) do
      records.each do |record|
        FactoryBot.create(:record_like, user:, record:)
      end
    end

    it "ユーザーがいいねした記録が取得を取得する" do
      get likes_api_v1_user_path(id: user.uid)
      json = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(json.size).to eq(5)
      expect(json[0]["record_likes"][0]["user_id"]).to eq(user.id)
    end
  end

  describe 'GET /user/{id}/attend' do
    let(:events) { FactoryBot.create_list(:event, 5, user:) }
    let!(:event_attendees) do
      events.each do |event|
        FactoryBot.create(:event_attendee, user:, event:)
      end
    end

    it "ユーザーが参加予約したイベントが取得を取得する" do
      get attend_api_v1_user_path(id: user.uid)
      json = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(json.size).to eq(5)
      expect(json[0]["user"]["uid"]).to eq(user.uid)
    end
  end

  describe 'GET /user/record_bookmarks' do
    let(:records) { FactoryBot.create_list(:record, 5, user:) }
    let!(:record_bookmarks) do
      records.each do |record|
        FactoryBot.create(:record_bookmark, user:, record:)
      end
    end

    context "jwtが有効な場合" do
      it "ユーザーがブックマークした記録を取得できる" do
        authenticate_stub
        get(record_bookmarks_api_v1_users_path, headers:)
        json = JSON.parse(response.body)

        expect(response.status).to eq(200)
        expect(json.size).to eq(5)
        expect(json[0]["record_bookmarks"][0]["user"]["uid"]).to eq(user.uid)
      end
    end

    context "jwtが無効な場合" do
      it "ユーザーがブックマークした記録を取得できない" do
        get(record_bookmarks_api_v1_users_path, headers:)
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'GET /user/event_bookmarks' do
    let(:events) { FactoryBot.create_list(:event, 5, user:) }
    let!(:event_bookmarks) do
      events.each do |event|
        FactoryBot.create(:event_bookmark, user:, event:)
      end
    end

    context "jwtが有効な場合" do
      it "ユーザーがブックマークした記録を取得できる" do
        authenticate_stub
        get(event_bookmarks_api_v1_users_path, headers:)
        json = JSON.parse(response.body)

        expect(response.status).to eq(200)
        expect(json.size).to eq(5)
        expect(json[0]["event_bookmarks"][0]["user"]["uid"]).to eq(user.uid)
      end
    end

    context "jwtが無効な場合" do
      it "ユーザーがブックマークした記録を取得できない" do
        get(event_bookmarks_api_v1_users_path, headers:)
        expect(response.status).to eq(401)
      end
    end
  end
end

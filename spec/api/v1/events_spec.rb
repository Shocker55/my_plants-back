require 'rails_helper'

describe Api::V1::EventsController, type: :request do
  include AuthenticationHelper
  let(:headers) { { CONTENT_TYPE: 'application/json', Authorization: "Bearer #{ENV['TOKEN']}" } }

  describe "GET /events" do
    it "全ての記録を取得する" do
      FactoryBot.create_list(:event, 8)
      get api_v1_events_path
      json = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(json.length).to eq(8)
    end
  end

  describe "GET /events/{id}" do
    let(:event) { FactoryBot.create(:event, title: 'test-title') }

    it "特定の記録を取得する" do
      get api_v1_event_path(event)
      json = JSON.parse(response.body)

      expect(response.status).to eq(200)
      # 要求した特定のポストのみ取得した事を確認する
      expect(json["title"]).to eq(event.title)
    end
  end

  describe "POST /events" do
    let(:params) do
      { title: "Lorem", body: "Lorem ipsum", start_date: Date.today + 7,
        end_date: Date.today + 14, place: "Example Place", latitude: rand.to_s,
        longitude: rand.to_s, date_type: "month_only" }
    end

    it "記録を作成できる" do
      authenticate_stub

      expect { post api_v1_events_path, params: params.to_json, headers: }.to change(Event, :count).by(+1)

      expect(response.status).to eq(201)
    end

    it "jwt有効期限が切れていたら記録を作成できない" do
      post(api_v1_events_path, params: params.to_json, headers:)

      expect(response.status).to eq(401)
      expect(Event.count).to eq(0)
    end
  end

  describe "PATCH /events/{id}" do
    let(:event) { FactoryBot.create(:event, title: "old-title") }

    context "jwtが有効な場合" do
      it "記録を編集できる" do
        authenticate_stub
        patch(api_v1_event_path(event), params: { title: "new-title" }.to_json, headers:)

        expect(response.status).to eq(201)
      end
    end

    context "jwtが無効な場合" do
      it "記録を編集できない" do
        patch(api_v1_event_path(event), params: { title: "new-title" }.to_json, headers:)

        expect(response.status).to eq(401)
      end
    end
  end

  describe "DELETE /events/{id}" do
    let!(:event) { FactoryBot.create(:event) }

    context "jwtが有効な場合" do
      it "記録を削除できる" do
        authenticate_stub
        expect { delete api_v1_event_path(event), headers: }.to change(Event, :count).by(-1)

        expect(response.status).to eq(204)
      end
    end

    context "jwtが無効な場合" do
      it "記録を削除できない" do
        delete(api_v1_event_path(event), headers:)

        expect(response.status).to eq(401)
      end
    end
  end
end

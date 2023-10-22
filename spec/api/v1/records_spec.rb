require 'rails_helper'

describe Api::V1::RecordsController, type: :request do
  include AuthenticationHelper
  let(:headers) { { CONTENT_TYPE: 'application/json', Authorization: "Bearer #{ENV['TOKEN']}" } }

  describe "GET /records" do
    it "全ての記録を取得する" do
      FactoryBot.create_list(:record, 8)
      get api_v1_records_path
      json = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(json.length).to eq(8)
    end
  end

  describe "GET /records/{id}" do
    let(:record) { FactoryBot.create(:record, title: 'test-title') }

    it "特定の記録を取得する" do
      get api_v1_record_path(record)
      json = JSON.parse(response.body)

      expect(response.status).to eq(200)
      # 要求した特定のポストのみ取得した事を確認する
      expect(json["title"]).to eq(record.title)
    end
  end

  describe "POST /records" do
    let(:params) { { title: "Lorem", body: "Lorem ipsum", tags: "", base: "true" } }

    it "記録を作成できる" do
      authenticate_stub

      expect { post api_v1_records_path, params: params.to_json, headers: }.to change(Record, :count).by(+1)
      expect(response.status).to eq(201)
    end

    it "jwt有効期限が切れていたら記録を作成できない" do
      post(api_v1_records_path, params: params.to_json, headers:)

      expect(response.status).to eq(401)
      expect(Record.count).to eq(0)
    end
  end

  describe "PATCH /records/{id}" do
    let(:record) { FactoryBot.create(:record, title: "old-title") }

    context "jwtが有効な場合" do
      it "記録を編集できる" do
        authenticate_stub
        patch(api_v1_record_path(record), params: { title: "new-title", tags: "" }.to_json, headers:)

        expect(response.status).to eq(201)
      end
    end

    context "jwtが無効な場合" do
      it "記録を編集できない" do
        patch(api_v1_record_path(record), params: { title: "new-title", tags: "" }.to_json, headers:)

        expect(response.status).to eq(401)
      end
    end
  end

  describe "DELETE /records/{id}" do
    let!(:record) { FactoryBot.create(:record) }

    context "jwtが有効な場合" do
      it "記録を削除できる" do
        authenticate_stub
        expect { delete api_v1_record_path(record), headers: }.to change(Record, :count).by(-1)

        expect(response.status).to eq(204)
      end
    end

    context "jwtが無効な場合" do
      it "記録を削除できない" do
        delete(api_v1_record_path(record), headers:)

        expect(response.status).to eq(401)
      end
    end
  end
end

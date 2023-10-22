require 'rails_helper'

describe Api::V1::RecordCommentsController, type: :request do
  include AuthenticationHelper
  let(:headers) { { CONTENT_TYPE: 'application/json', Authorization: "Bearer #{ENV['TOKEN']}" } }
  let(:record) { FactoryBot.create(:record) }

  describe 'POST /record_bookmarks' do
    context "jwtが有効な場合" do
      it '記録にブックマークができる' do
        authenticate_stub

        expect do
          post api_v1_record_bookmarks_path, params: { record_id: record.id }.to_json,
                                             headers:
        end.to change(RecordBookmark, :count).by(+1)
        expect(response.status).to eq(201)
      end
    end

    context "jwtが無効な場合" do
      it "記録にいいねができない" do
        post(api_v1_record_bookmarks_path, params: { record_id: record.id }.to_json, headers:)

        expect(response.status).to eq(401)
        expect(RecordBookmark.count).to eq(0)
      end
    end
  end

  describe "DELETE /record_bookmarks/{id}" do
    let!(:record_bookmark) { FactoryBot.create(:record_bookmark, record:) }

    context "jwtが有効な場合" do
      it 'いいねが削除できる' do
        authenticate_stub
        expect { delete api_v1_record_bookmark_path(record), headers: }.to change(RecordBookmark, :count).by(-1)

        expect(response.status).to eq(204)
      end
    end

    context "jwtが無効な場合" do
      it "いいねが削除できない" do
        delete(api_v1_record_bookmark_path(record), headers:)

        expect(response.status).to eq(401)
        expect(RecordBookmark.count).to eq(1)
      end
    end
  end
end

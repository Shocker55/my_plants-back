require 'rails_helper'

describe Api::V1::EventCommentsController, type: :request do
  include AuthenticationHelper
  let(:headers) { { CONTENT_TYPE: 'application/json', Authorization: "Bearer #{ENV['TOKEN']}" } }
  let(:event) { FactoryBot.create(:event) }

  describe 'POST /event_bookmarks' do
    context "jwtが有効な場合" do
      it '記録にブックマークができる' do
        authenticate_stub

        expect do
          post api_v1_event_bookmarks_path, params: { event_id: event.id }.to_json,
                                            headers:
        end.to change(EventBookmark, :count).by(+1)
        expect(response.status).to eq(201)
      end
    end

    context "jwtが無効な場合" do
      it "記録にブックマークができない" do
        post(api_v1_event_bookmarks_path, params: { event_id: event.id }.to_json, headers:)

        expect(response.status).to eq(401)
        expect(EventBookmark.count).to eq(0)
      end
    end
  end

  describe "DELETE /event_bookmarks/{id}" do
    let!(:event_bookmark) { FactoryBot.create(:event_bookmark, event:) }

    context "jwtが有効な場合" do
      it 'ブックマークが削除できる' do
        authenticate_stub
        expect { delete api_v1_event_bookmark_path(event), headers: }.to change(EventBookmark, :count).by(-1)

        expect(response.status).to eq(204)
      end
    end

    context "jwtが無効な場合" do
      it "ブックマークが削除できない" do
        delete(api_v1_event_bookmark_path(event), headers:)

        expect(response.status).to eq(401)
        expect(EventBookmark.count).to eq(1)
      end
    end
  end
end

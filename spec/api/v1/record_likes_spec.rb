require 'rails_helper'

describe Api::V1::RecordCommentsController, type: :request do
  include AuthenticationHelper
  let(:headers) { { CONTENT_TYPE: 'application/json', Authorization: "Bearer #{ENV['TOKEN']}" } }
  let(:record) { FactoryBot.create(:record) }

  describe 'POST /record_likes' do
    context "jwtが有効な場合" do
      it '記録にいいねができる' do
        authenticate_stub

        expect do
          post api_v1_record_likes_path, params: { record_id: record.id }.to_json,
                                         headers:
        end.to change(RecordLike, :count).by(+1)
        expect(response.status).to eq(201)
      end
    end

    context "jwtが無効な場合" do
      it "記録にいいねができない" do
        post(api_v1_record_likes_path, params: { record_id: record.id }.to_json, headers:)

        expect(response.status).to eq(401)
        expect(RecordLike.count).to eq(0)
      end
    end
  end

  describe "DELETE /record_likes/{id}" do
    let!(:record_like) { FactoryBot.create(:record_like, record:) }

    context "jwtが有効な場合" do
      it 'いいねが削除できる' do
        authenticate_stub
        expect { delete api_v1_record_like_path(record), headers: }.to change(RecordLike, :count).by(-1)

        expect(response.status).to eq(204)
      end
    end

    context "jwtが無効な場合" do
      it "いいねが削除できない" do
        delete(api_v1_record_like_path(record), headers:)

        expect(response.status).to eq(401)
        expect(RecordLike.count).to eq(1)
      end
    end
  end
end

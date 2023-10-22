require 'rails_helper'

describe Api::V1::RecordCommentsController, type: :request do
  include AuthenticationHelper
  let(:headers) { { CONTENT_TYPE: 'application/json', Authorization: "Bearer #{ENV['TOKEN']}" } }
  let(:record) { FactoryBot.create(:record) }

  describe 'POST /records/{id}/record_comments' do
    let(:params) { { comment: "new comment" } }

    context "jwtが有効な場合" do
      it 'コメントが投稿できる' do
        authenticate_stub

        expect do
          post api_v1_record_record_comments_path(record), params: params.to_json,
                                                           headers:
        end.to change(RecordComment, :count).by(+1)
        expect(response.status).to eq(201)
      end
    end

    context "jwtが無効な場合" do
      it "コメントが投稿できない" do
        post(api_v1_record_record_comments_path(record), params: params.to_json, headers:)

        expect(response.status).to eq(401)
        expect(RecordComment.count).to eq(0)
      end
    end
  end

  describe "DELETE /record_comments/{id}" do
    let!(:record_comment) { FactoryBot.create(:record_comment, record:) }

    context "jwtが有効な場合" do
      it 'コメントが削除できる' do
        authenticate_stub
        expect { delete api_v1_record_comment_path(record_comment), headers: }.to change(RecordComment, :count).by(-1)

        expect(response.status).to eq(204)
      end
    end

    context "jwtが無効な場合" do
      it "コメントが投稿できない" do
        delete(api_v1_record_comment_path(record_comment), headers:)

        expect(response.status).to eq(401)
        expect(RecordComment.count).to eq(1)
      end
    end
  end
end

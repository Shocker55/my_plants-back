require 'rails_helper'

describe Api::V1::EventCommentsController, type: :request do
  include AuthenticationHelper
  let(:headers) { { CONTENT_TYPE: 'application/json', Authorization: "Bearer #{ENV['TOKEN']}" } }
  let(:event) { FactoryBot.create(:event) }

  describe 'POST /events/{id}/event_comments' do
    let(:params) { { comment: "new comment" } }

    context "jwtが有効な場合" do
      it 'コメントが投稿できる' do
        authenticate_stub

        expect do
          post api_v1_event_event_comments_path(event), params: params.to_json,
                                                        headers:
        end.to change(EventComment, :count).by(+1)
        expect(response.status).to eq(201)
      end
    end

    context "jwtが無効な場合" do
      it "コメントが投稿できない" do
        post(api_v1_event_event_comments_path(event), params: params.to_json, headers:)

        expect(response.status).to eq(401)
        expect(EventComment.count).to eq(0)
      end
    end
  end

  describe "DELETE /event_comments/{id}" do
    let!(:event_comment) { FactoryBot.create(:event_comment, event:) }

    context "jwtが有効な場合" do
      it 'コメントが削除できる' do
        authenticate_stub
        expect { delete api_v1_event_comment_path(event_comment), headers: }.to change(EventComment, :count).by(-1)

        expect(response.status).to eq(204)
      end
    end

    context "jwtが無効な場合" do
      it "コメントが投稿できない" do
        delete(api_v1_event_comment_path(event_comment), headers:)

        expect(response.status).to eq(401)
        expect(EventComment.count).to eq(1)
      end
    end
  end
end

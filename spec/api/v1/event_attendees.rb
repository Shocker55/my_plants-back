require 'rails_helper'

describe Api::V1::EventAttendeesController, type: :request do
  include AuthenticationHelper
  let(:headers) { { CONTENT_TYPE: 'application/json', Authorization: "Bearer #{ENV['TOKEN']}" } }
  let(:event) { FactoryBot.create(:event) }
  let(:user) { FactoryBot.create(:user) }

  describe 'POST /event_attendees' do
    context "jwtが有効な場合" do
      it 'イベントに参加予約ができる' do
        authenticate_stub

        expect do
          post api_v1_event_attendees_path, params: { event_id: event.id }.to_json,
                                            headers:
        end.to change(EventBookmark, :count).by(+1)
        expect(response.status).to eq(201)
      end
    end

    context "jwtが無効な場合" do
      it "イベントに参加予約ができない" do
        post(api_v1_event_attendees_path, params: { event_id: event.id }.to_json, headers:)

        expect(response.status).to eq(401)
        expect(EventAttendee.count).to eq(0)
      end
    end
  end

  describe "DELETE /event_attendees/{id}" do
    let!(:event_attendee) { FactoryBot.create(:event_attendee, event:) }

    context "jwtが有効な場合" do
      it '参加予約が削除できる' do
        authenticate_stub
        expect { delete api_v1_event_attendee_path(event), headers: }.to change(EventAttendee, :count).by(-1)

        expect(response.status).to eq(204)
      end
    end

    context "jwtが無効な場合" do
      it "参加予約が削除できない" do
        delete(api_v1_event_attendee_path(event), headers:)

        expect(response.status).to eq(401)
        expect(EventBookmark.count).to eq(1)
      end
    end
  end
end

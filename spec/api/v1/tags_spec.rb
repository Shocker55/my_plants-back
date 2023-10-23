require 'rails_helper'

describe Api::V1::TagsController, type: :request do
  let(:records) { FactoryBot.create_list(:record, 3) }
  let(:tags) { FactoryBot.create_list(:tag, 3) }
  let!(:record_tags) do
    records.each do |record|
      tags.each do |tag|
        FactoryBot.create(:record_tag, record:, tag:)
      end
    end
  end

  describe 'GET /tags' do
    it "タグが取得できる" do
      get api_v1_tags_path
      json = JSON.parse(response.body)

      expect(response.status).to eq(200)
      # タグの数が3であることを検証
      expect(json.size).to eq(3)
    end
  end
end

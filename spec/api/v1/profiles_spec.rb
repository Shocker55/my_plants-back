require 'rails_helper'

describe Api::V1::UsersController, type: :request do
  include AuthenticationHelper
  let(:headers) { { CONTENT_TYPE: "application/json", Authorization: "Bearer #{ENV['TOKEN']}" } }

  describe "POST /profiles" do
    params = { name: "John", avatar: "avatar_url", bio: "Sample bio" }

    it "プロファイルを作成できる" do
      authenticate_stub
      expect { post api_v1_profiles_path, params: params.to_json, headers: }.to change(Profile, :count).by(+1)

      expect(response.status).to eq(201)
    end

    it "jwt有効期限が切れていたらプロファイルを作成できない" do
      post(api_v1_profiles_path, params: params.to_json, headers:)

      expect(response.status).to eq(401)
      expect(Profile.count).to eq(0)
    end
  end

  describe "PATCH /profiles/{id}" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:profile) { FactoryBot.create(:profile, user:) }
    let(:other_user) { FactoryBot.create(:archer) }
    let(:other_profile) { FactoryBot.create(:archer_profile, user: other_user) }

    params = { name: "John", avatar: "avatar_url", bio: "Sample bio" }

    context "jwtが有効な場合" do
      it "プロフィールを編集できる" do
        authenticate_stub
        patch(api_v1_profile_path(profile), params: { name: "new-name" }.to_json, headers:)

        expect(response.status).to eq(201)
      end

      it "admin属性の変更はできない" do
        expect(profile).to_not be_admin
        authenticate_stub
        patch(api_v1_profile_path(profile), params: params.merge(role: "admin").to_json,
                                            headers:)
        user.reload

        expect(profile).to_not be_admin
      end

      it "他のユーザーのプロフィールは変更できない" do
        expect(other_profile).to have_attributes(name: "Archer", bio: "Archer's Bio")
        authenticate_stub
        patch(api_v1_profile_path(other_profile), params: params.to_json, headers:)
        other_user.reload

        expect(other_profile).to have_attributes(name: "Archer", bio: "Archer's Bio")
      end
    end

    context "jwtが無効な場合" do
      it "プロフィールを編集できない" do
        patch(api_v1_profile_path(profile), params: { name: "new-name" }.to_json, headers:)

        expect(response.status).to eq(401)
      end
    end
  end
end

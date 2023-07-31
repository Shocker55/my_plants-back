require "test_helper"

class Api::V1::ProfilesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_v1_profiles_create_url
    assert_response :success
  end
end

require "test_helper"

class Api::V1::AuthenticationsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_v1_authentications_create_url
    assert_response :success
  end
end

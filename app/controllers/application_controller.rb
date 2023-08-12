class ApplicationController < ActionController::API
  include FirebaseAuth
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  def authenticate
    # Authorization: Token ${token} or Bearer ${token}がない場合スキップされる
    authenticate_with_http_token do |token, _options|
      result = verify_id_token(token)
      if result
        # debugger
        @_current_user = User.find_or_create_by(uid: result[:uid])
      end
    end
    { error: "token invalid" }
  end

  def current_user
    @_current_user
  end
end

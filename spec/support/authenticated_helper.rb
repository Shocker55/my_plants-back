module AuthenticationHelper
  def authenticate_stub
    # 渡したいインスタンス変数を定義
    @user_info = [
      {
        'name' => 'test',
        'email' => 'test@example.com',
        'email_verified' => true
      }
    ]

    # allow_any_instance_ofメソッドを使ってauthenticateメソッドが呼ばれたら
    # ↑のインスタンス変数を返す
    allow_any_instance_of(ApplicationController).to receive(:authenticate).and_return(@user_info)

    # current_user を設定することにより、ユーザーオブジェクトを作成
    user = User.find_or_create_by(uid: 'JwMbY12MZCOk3A4eGQfGo3wLUVG2')

    # user を current_user に設定
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end
end

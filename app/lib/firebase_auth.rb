# gem jwt を使ってJWTのデコード
require "jwt"
# HTTPプロトコル を扱うライブラリ
require "net/http"

# https://firebase.google.com/docs/auth/admin/verify-id-tokens#verify_id_tokens_using_a_third-party_jwt_library
module FirebaseAuth
  ALGORITHM = "RS256".freeze
  ISSUER_BASE_URL = "https://securetoken.google.com/".freeze
  FIREBASE_PROJECT_ID = ENV["FIREBASE_PROJECT_ID"]

  # 公開鍵をGoogleから取得するためのURL
  CERT_URL =
    "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com".freeze

  def verify_id_token(token)
    # debugger
    raise 'id token must be a String' unless token.is_a?(String)

    full_decoded_token = _decode_token(token)

    err_msg = _validate_jwt(full_decoded_token)
    raise err_msg if err_msg

    public_key = _fetch_public_keys[full_decoded_token[:header]['kid']]
    unless public_key
      raise 'Firebase ID token has "kid" claim which does not correspond to ' +
        'a known public key. Most likely the ID token is expired, so get a fresh token from your client ' +
        'app and try again.'
    end
    #公開鍵から証明書を作成
    certificate = OpenSSL::X509::Certificate.new(public_key)
    #証明書を利用しトークンを再度デコード
    decoded_token = _decode_token(token, certificate.public_key, true, { algorithm: ALGORITHM, verify_iat: true })

    { uid: decoded_token[:payload]['sub'], decoded_token: decoded_token }
  end

  private

  # デコードしてpalyoadとheaderを取得
  # JWTの有効期限が切れていればエラーになる
  # Returns:
  #    Array: decoded data of ID token =>
  #     [
  #      {"data"=>"data"}, # payload
  #      {"typ"=>"JWT", "alg"=>"alg", "kid"=>"kid"} # header
  #     ]
  def _decode_token(token, key=nil, verify=false, options={})
    begin
      decoded_token = JWT.decode(token, key, verify, options)
    rescue JWT::ExpiredSignature => e
      raise 'Firebase ID token has expired. Get a fresh token from your client app and try again.'
    rescue => e
      raise "Firebase ID token has invalid signature. #{e.message}"
    end

    { payload: decoded_token[0], header: decoded_token[1] }
  end

  # 公開鍵をGoogleから取得
  def _fetch_public_keys
    uri = URI.parse(CERT_URL)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    res = https.start {
      https.get(uri.request_uri)
    }
    data = JSON.parse(res.body)

    if (data['error']) then
      msg = 'Error fetching public keys for Google certs: ' + data['error']
      msg += " (#{res['error_description']})" if (data['error_description'])

      raise msg
    end

    data
  end

  def _validate_jwt(json)
    project_id = FIREBASE_PROJECT_ID
    payload = json[:payload]
    header = json[:header]

    return 'Firebase ID token has no "kid" claim.' unless header['kid']
    return "Firebase ID token has incorrect algorithm. Expected \"#{ALGORITHM}\" but got \"#{header['alg']}\"." unless header['alg'] == ALGORITHM
    return "Firebase ID token has incorrect \"aud\" (audience) claim. Expected \"#{FIREBASE_PROJECT_ID}\" but got \"#{payload['aud']}\"." unless payload['aud'] == FIREBASE_PROJECT_ID

    issuer = ISSUER_BASE_URL + FIREBASE_PROJECT_ID
    return "Firebase ID token has incorrect \"iss\" (issuer) claim. Expected \"#{issuer}\" but got \"#{payload['iss']}\"."  unless payload['iss'] == issuer

    return 'Firebase ID token has no "sub" (subject) claim.' unless payload['sub'].is_a?(String)
    return 'Firebase ID token has an empty string "sub" (subject) claim.'  if payload['sub'].empty?
    return 'Firebase ID token has "sub" (subject) claim longer than 128 characters.' if payload['sub'].size > 128

    nil
  end
end

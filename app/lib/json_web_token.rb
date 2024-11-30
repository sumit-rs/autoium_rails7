class JsonWebToken
  SECRET_KEY = ENV[:secret]

  def self.encode(payload, exp = 1.hours.from_now.to_i)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError => e
    nil
  end

  def self.tokenIsValid?(token)
    Time.now.to_i <= token[:exp]
  end
end

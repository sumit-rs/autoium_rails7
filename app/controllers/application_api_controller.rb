class ApplicationApiController < ActionController::API
  before_action :authorize_request
  before_action :check_current_user

  def authorize_request
    token = (request.headers['Authorization'] || '').split(' ')[1]
    token_info = JsonWebToken.decode(token)
    if token_info.present? and JsonWebToken.tokenIsValid?(token_info)
      Current.user = User.where(email: token_info.dig("email")).take
    end
  rescue JWT::DecodeError
    render json: { errors: 'Unauthorized' }, status: :unauthorized
  end

  def check_current_user
    unless Current.user
      response.headers['session_expired'] = 'true'
      response.headers['Logout'] = 'true'
      _messages = ["Current user not found. Request needs a valid JWT-TOKEN as custom header."]
      render(json: {message: _messages.join(" ")}, status: :precondition_failed)
    end
  end
end

class Api::V1::UsersController < ApplicationApiController
  skip_before_action :authorize_request, only: %i[login logout]
  skip_before_action :check_current_user, only: %i[login logout]

  def login
    email = params.dig('data','email_address')
    password = params.dig('data','password')
    if(email.present? and password.present?)
      user = User.where(email: email).first
      valid_password = user&.authenticate(password)
      if valid_password
        token = User.generate_jwt_token(user.email)
        render(json: {
                        message: 'Successfully logged in!',
                        result: {
                          "accessToken": token
                        },
                        status: true
                      },
                      status: :ok
        )
      else
        render(json: {message: 'Invalid email or password.'}, status: :precondition_failed)
      end
    else
      render(json: {message: 'Invalid email or password.'}, status: :precondition_failed)
    end
  end

  def logout
    Current.user = nil
    render(json: {message: 'Successfully logged out!.', status: true, result: true}, status: :ok)
  end

end
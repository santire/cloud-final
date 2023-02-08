class ApplicationController < Jets::Controller::Base
  before_action :authenticate

  attr_reader :current_user

  def authenticate
    id_token = headers['authorization']
    return if id_token.blank?

    decoded_token = JWT.decode(id_token, nil, false)

    render status: 401 if decoded_token.blank? || decoded_token[0]['email'].blank?

    # TODO: replace with DB fetch
    @current_user = User.find_by(email: decoded_token[0]['email'])
  end
end

class ApplicationController < ActionController::API
  # Include Knock within your application.
  include Knock::Authenticable

  protected

  # Method for checking if current_user is admin or not.
  def authorize_as_admin
    if current_user.nil?
      head :unauthorized
    elsif !current_user.is_admin?
      render json: { status: 200, msg: 'You do not have permission to delete a user' }
    end
  end
end

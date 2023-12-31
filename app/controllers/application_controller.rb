class ApplicationController < ActionController::API
  rescue_from StandardError, with: :handle_standard_error

  private

  def current_user
    @current_user
  end

  def handle_standard_error(e)
    render json: { error: e.message }, status: :internal_server_error
  end
end

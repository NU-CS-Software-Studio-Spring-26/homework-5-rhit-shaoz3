class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    return if logged_in?

    redirect_to new_session_path, alert: "You must be logged in to continue."
  end

  def authorize_todo_owner!
    return if @todo.user_id == current_user.id

    respond_to do |format|
      format.html { redirect_to todos_path, alert: "You can only mark your own todos as done." }
      format.json { head :forbidden }
    end
  end
end

class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to todos_path, notice: "Logged in successfully."
    else
      redirect_to todos_path, alert: "Invalid email or password."
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to todos_path, notice: "Logged out.", status: :see_other
  end
end

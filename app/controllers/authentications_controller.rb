class AuthenticationsController < ApplicationController
  before_filter :authenticate_user!

  def create
    omniauth = request.env["omniauth.auth"]
    current_user.add_auth omniauth
    redirect_to feed_path
  end

  # Delete auth
  def destroy
    Authentication.where(:user_id => current_user.id).destroy(params[:id])
    redirect_to :root
  end
end

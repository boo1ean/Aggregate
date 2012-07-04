class AuthenticationsController < ApplicationController
  def create
    if user_signed_in?
      omniauth = request.env["omniauth.auth"]
      current_user.add_auth omniauth
      redirect_to :root
    end
  end
end

class IndexController < ApplicationController
  def index
    if user_signed_in?
      @auth = current_user.authentications
      render :auth_list
    end
  end
end

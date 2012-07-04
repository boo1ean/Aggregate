class SocialController < ApplicationController
  before_filter :authenticate_user!

  def index
    @feed = current_user.feed
  end
end

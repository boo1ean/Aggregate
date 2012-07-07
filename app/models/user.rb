require "feed_factory"

class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :remember_me
  devise   :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable

  has_many :authentications
  has_many :providers, :through => :authentications

  # Add new auth for current user
  def add_auth(omniauth)
    provider_id = Provider.find_by_name(omniauth.provider)
    params      = { :uid => omniauth.uid, :provider => provider_id }

    if omniauth.credentials
      params[:token]      = omniauth.credentials.token
      params[:secret]     = omniauth.credentials.secret
      params[:expires_at] = omniauth.credentials.expires_at
    end

    auth = authentications.create(params)
  end

  # Get missing providers
  def missing_providers
    all_auth     = Provider.all.collect  { |a| a.name }
    current_auth = providers.collect     { |a| a.name }

    # Just return difference between all an current
    all_auth - current_auth
  end

  # Get full feed
  def feed
    @feed = []

    authentications.each do |auth|
      @feed += FeedFactory.create(auth.provider.name, auth.token, auth.secret).feed
    end

    # Desc sort by created_at
    @feed.sort { |a,b| b[:created_at] <=> a[:created_at] }
  end

end

class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :remember_me
  devise   :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable

  has_many :authentications
  has_many :providers, :through => :authentications

  def add_auth(omniauth)
    provider_id = Provider.find_by_name(omniauth.provider)
    params      = { :uid => omniauth.uid, :provider => provider_id }

    if omniauth.credentials
      params[:token]  = omniauth.credentials.token
      params[:secret] = omniauth.credentials.secret
    end

    auth = authentications.create(params)
  end

  def feed
    result = []
    authentications.each do |auth|
      case auth.provider.name
      when 'twitter'
        result |= twitter_feed auth.token, auth.secret
      else
        # Default
      end
    end

    result
  end

  private
  # Get data from twitter
  def twitter_feed(token, secret)
    result = []

    Twitter.configure do |config|
      config.consumer_key       = Aggregate::Application.config.API["TWITTER_CONSUMER_KEY"]
      config.consumer_secret    = Aggregate::Application.config.API["TWITTER_CONSUMER_SECRET"]
      config.oauth_token        = token
      config.oauth_token_secret = secret
    end

    timeline = Twitter.home_timeline.each do |item|
      result << { :created_at => item.created_at, :body => item.text, :user => item.user.screen_name }
    end

    result
  end
end

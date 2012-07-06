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
      case auth.provider.name
      when "twitter"  
        twitter_feed auth.token, auth.secret
      when "facebook" 
        facebook_feed auth.token
      when "vkontakte"
        vkontakte_feed auth.token
      else
      end
    end

    # Desc sort by created_at
    @feed.sort { |a,b| b[:created_at] <=> a[:created_at] }
  end

  private

  # Get data from twitter
  def twitter_feed(token, secret)
    Twitter.configure do |config|
      config.consumer_key       = Aggregate::Application.config.API["TWITTER_CONSUMER_KEY"]
      config.consumer_secret    = Aggregate::Application.config.API["TWITTER_CONSUMER_SECRET"]
      config.oauth_token        = token
      config.oauth_token_secret = secret
    end

    @feed += parse_twitter_feed Twitter.home_timeline(:count => 5)
  end

  def parse_twitter_feed(feed)
    feed.collect do |item|
      {
        :created_at  => item.created_at,
        :body        => item.text,
        :screen_name => item.user.screen_name,
        :provider    => :twitter
      }
    end
  end

  # Get data from facebook
  def facebook_feed(token)
    @graph = Koala::Facebook::API.new(token)

    @feed += parse_facebook_feed @graph.get_connections("me", "home", :limit => 10)
  end

  def parse_facebook_feed(feed)
    feed.collect do |item|
      {
        :created_at => Time.parse(item["created_time"]),
        :body       => item["story"],
        :user_name  => item["from"]["name"],
        :user_id    => item["from"]["id"],
        :provider   => :facebook
      }
    end
  end

  # Ged data from vkontakte
  def vkontakte_feed(token)
    vk = VkontakteApi::Client.new(token)
    @feed += parse_vkontakte_feed vk.newsfeed.get(:count => 5)
  end

  def parse_vkontakte_feed(feed)
    feed[:items].collect do |item|
      {
        :created_at => Time.at(item[:date]),
        :body       => item[:text],
        :type       => item[:type],
        :provider   => :vkontakte
      }
    end
  end

end

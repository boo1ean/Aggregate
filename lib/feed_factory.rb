# FeedFactory provides possibility to get feed from allowed providers.
#
# List of allowed providers:
#  * facebook
#  * twitter
#  * vkontakte
#
#  You can call "feed" method on any of Feed class instances to get formatted feed.
module FeedFactory

  # Create instance of feed.
  # Just pass provider name and access token and secret if necessary.
  # Example:
  #   FeedFactory.create("facebook", token) -> return instance of FacebookFeed
  #   FeedFactory.create("twitter", token, secret) -> return instance of TwitterFeed
  def self.create(provider, *args)
    FeedFactory.const_get("#{provider.classify}Feed").new(*args)
  end

  private
  # Base feed's class implements method for feed fetching
  class Feed
    # Return specified number of feed entries
    def feed(count = 5)
      data = get_data(count)
      parse_data data
    end
  end

  class TwitterFeed < Feed
    PROVIDER = :twitter

    # Set up api driver
    def initialize(token, secret)
      Twitter.configure do |config|
        config.consumer_key       = Aggregate::Application.config.API["TWITTER_CONSUMER_KEY"]
        config.consumer_secret    = Aggregate::Application.config.API["TWITTER_CONSUMER_SECRET"]
        config.oauth_token        = token
        config.oauth_token_secret = secret
      end
    end

    private
    # Get data from resource server
    def get_data(count)
      Twitter.home_timeline(:count => count)
    end

    def parse_data(data)
      data.collect do |item|
        {
          :created_at  => item.created_at,
          :body        => item.text,
          :screen_name => item.user.screen_name,
          :provider    => :twitter
        }
      end
    end
  end

  class FacebookFeed < Feed
    PROVIDER = :facebook

    # Set up api driver
    def initialize(token, secret = nil)
      @api = Koala::Facebook::API.new(token)
    end

    private
    # Get data from resource server
    def get_data(limit)
      @api.get_connections("me", "home", :limit => limit)
    end

    def parse_data(data)
      data.collect do |item|
        {
          :provider   => PROVIDER,
          :created_at => Time.parse(item["created_time"]),
          :body       => item["story"],
          :user_name  => item["from"]["name"],
          :user_id    => item["from"]["id"]
        }
      end
    end
  end

  class VkontakteFeed < Feed
    PROVIDER = :vkontakte
    PHOTO    = "photo"

    # Set up api driver
    def initialize(token, secret = nil)
      @api = VkontakteApi::Client.new(token)
    end

    private 
    # Get data from resource server
    def get_data(count)
      @api.newsfeed.get(:count => count)
    end

    def parse_data(data)
      data[:items].collect do |item|

        entry = {
          :provider   => PROVIDER,
          :created_at => Time.at(item[:date]),
        }

        case item[:type]
        when "post"
          entry[:body] = item[:text]
        end

        entry[:attachments] = parse_attachments item if item[:attachments]

        entry
      end
    end

    def parse_attachments(item)
      item[:attachments].collect do |a|
        case a[:type]
        when PHOTO 
          { :type => :photo, :src => a[:photo][:src_big] }
        end
      end
    end
  end
end

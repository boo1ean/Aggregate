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
    def feed(count = 7)
      @data = get_data(count)
      parse_data @data
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

    # Post types
    LINK   = "link"
    STATUS = "status"

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
        entry = {
          :provider   => PROVIDER,
          :created_at => Time.parse(item["created_time"]),
          :body       => item["story"],
          :user_name  => item["from"]["name"],
          :user_id    => item["from"]["id"],
          :type       => item["type"]
        }

        case entry[:type]
        when LINK
          entry[:description] = item["description"]
          entry[:name]        = item["name"]
          entry[:link]        = item["link"]
        when STATUS
        end

        entry
      end
    end
  end

  class VkontakteFeed < Feed
    PROVIDER = :vkontakte
    POST     = "post"

    # Attachment types
    PHOTO = "photo"
    LINK  = "link"
    AUDIO = "audio"
    VIDEO = "video"

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
        when POST
          entry[:body] = item[:text]
        end

        entry[:user]        = get_entry_user_name item
        entry[:attachments] = parse_attachments item if item[:attachments]

        entry
      end
    end

    def parse_attachments(item)
      item[:attachments].collect do |a|
        case a[:type]
        when PHOTO 
          { :type => :photo, :src => a[:photo][:src_big] }
        when LINK
          { :type => :link, :url => a[:link][:url], :title => a[:link][:title] }
        when AUDIO
          { :type => :audio }
        when VIDEO
          { :type => :video }
        end
      end
    end

    def get_entry_user_name(entry)
      source_id = entry[:source_id].abs

      # Try to get user
      index = @data[:profiles].index { |p| source_id == p[:uid] }

      user = {}
      if index
        user_data   = @data[:profiles][index]
        user[:name] = "#{user_data[:last_name]} #{user_data[:first_name]}"
      else
        # If can't find user, try to find group
        index       = @data[:groups].index { |g| source_id == g[:gid] }
        user_data   = @data[:groups][index]
        user[:name] = user_data[:name]
      end

      user[:link]  = "http://vk.com/#{user_data[:screen_name]}"
      user[:photo] = user_data[:photo]

      user
    end
  end
end

Aggregate::Application.config.API = {}

# Twitter credentials
Aggregate::Application.config.API["TWITTER_CONSUMER_KEY"]    = "iVpVnCMAjBfNzLaybOih1w"
Aggregate::Application.config.API["TWITTER_CONSUMER_SECRET"] = "URxyIkZUdb93HUGI0oMbv1pAQHaGU2ZyijDzJQNrzY"

# Facebook credentials
Aggregate::Application.config.API["FACEBOOK_APP_ID"]     = "364128226993619"
Aggregate::Application.config.API["FACEBOOK_APP_SECRET"] = "97c804c0909a1738bf3bc3d32a71f9d1"

# Vk credentials
Aggregate::Application.config.API["VK_APP_ID"]     = "3008643"
Aggregate::Application.config.API["VK_APP_SECRET"] = "Md4vIS51UF7Lur4LlfEY"


TWITTER_CONSUMER_KEY    = Aggregate::Application.config.API["TWITTER_CONSUMER_KEY"]
TWITTER_CONSUMER_SECRET = Aggregate::Application.config.API["TWITTER_CONSUMER_SECRET"]

FACEBOOK_APP_ID     = Aggregate::Application.config.API["FACEBOOK_APP_ID"]
FACEBOOK_APP_SECRET = Aggregate::Application.config.API["FACEBOOK_APP_SECRET"]

VK_APP_ID     = Aggregate::Application.config.API["VK_APP_ID"]
VK_APP_SECRET = Aggregate::Application.config.API["VK_APP_SECRET"]

Rails.application.config.middleware.use OmniAuth::Builder do

  provider :twitter,  TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET

  provider :facebook, FACEBOOK_APP_ID,      FACEBOOK_APP_SECRET, {
    :client_options => { :ssl => { :ca_path => "/etc/ssl/certs" } },
    :scope          => "read_stream"
  }

  provider :vkontakte, VK_APP_ID, VK_APP_SECRET, {
    :client_options => { :ssl => { :ca_path => "/etc/ssl/certs" } }
  }
end

Aggregate::Application.config.API = {}
Aggregate::Application.config.API["TWITTER_CONSUMER_KEY"]    = "iVpVnCMAjBfNzLaybOih1w"
Aggregate::Application.config.API["TWITTER_CONSUMER_SECRET"] = "URxyIkZUdb93HUGI0oMbv1pAQHaGU2ZyijDzJQNrzY"

TWITTER_CONSUMER_KEY    = Aggregate::Application.config.API["TWITTER_CONSUMER_KEY"]
TWITTER_CONSUMER_SECRET = Aggregate::Application.config.API["TWITTER_CONSUMER_SECRET"]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET
end

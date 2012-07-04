TWITTER_CONSUMER_KEY    = "iVpVnCMAjBfNzLaybOih1w"
TWITTER_CONSUMER_SECRET = "URxyIkZUdb93HUGI0oMbv1pAQHaGU2ZyijDzJQNrzY"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET
end

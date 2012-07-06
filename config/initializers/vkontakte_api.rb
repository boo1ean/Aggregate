VkontakteApi.configure do |config|
  config.client_options = { :ssl => { :ca_path => "/etc/ssl/certs" } }
end

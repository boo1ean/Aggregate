class Authentication < ActiveRecord::Base
  attr_accessible :provider, :uid, :token, :secret, :expires_at
  belongs_to      :provider
  belongs_to      :user
end

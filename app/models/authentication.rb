class Authentication < ActiveRecord::Base
  attr_accessible :provider, :uid, :token, :secret
  belongs_to      :provider
  belongs_to      :user
end

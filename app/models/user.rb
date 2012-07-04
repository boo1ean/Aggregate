class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :authentications

  def add_auth(omniauth)
    auth = authentications.create(:uid => omniauth.uid, :provider => omniauth.provider)

    #if omniauth.credentials
      #auth.auth_credentials.create(:token => auth.credentials.token, :secret => auth.credentials.secret)
    #end
  end
end

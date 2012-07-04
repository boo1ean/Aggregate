class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :authentications

  def add_auth(omniauth)
    params = { :uid => omniauth.uid, :provider => omniauth.provider }

    if omniauth.credentials
      params[:token]  = omniauth.credentials.token
      params[:secret] = omniauth.credentials.secret
    end

    auth = authentications.create(params)
  end
end

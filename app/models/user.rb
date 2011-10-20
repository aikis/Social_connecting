class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :uid

  def apply_omniauth_twitter(auth, tokens)
    self.username = auth['screen_name'] if username.blank?
    self.uid = auth['id_str']
    self.oauth_token = tokens['token']
    self.oauth_secret = tokens['secret']
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    if user = User.find_by_email(data["email"])
      user
    else # Create a user with a stub password. 
      User.create(:email => data["email"], :password => Devise.friendly_token[0,20]) 
    end
  end

  def self.find_for_twitter_oauth(access_token, signed_in_resource=nil)
    id = access_token['uid']
    nick = access_token['user_info']['nickname'] if access_token['user_info']
    if user = User.find_by_uid(id)
      if signed_in_resource and signed_in_resource.id != user.id
        redirect_to :root, :notice => "This account have been already registered."
      else
        user
      end
    elsif signed_in_resource
      signed_in_resource.uid = id
    else
      User.create(:username => nick, :password => Devise.friendly_token[0,20], :uid => id) 
    end
  end

end

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :uid

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["user_hash"]
        user.fb_oauth_token = session["devise.facebook_data"]['credentials']['token']
        user.fb_oauth_secret = session["devise.facebook_data"]['credentials']['token']
      end
    end
  end

  def apply_omniauth_facebook(auth, tokens)
    self.username = auth['info']['name'] if username.blank?
    self.fb_oauth_token = tokens['token'] if fb_oauth_token/blank?
    self.fb_oauth_secret = tokens['secret'] if fb_oauth_secret/blank?
  end

  def apply_omniauth_twitter(auth, tokens)
    self.username = auth['screen_name'] if username.blank?
    self.uid = auth['id_str']
    self.oauth_token = tokens['token']
    self.oauth_secret = tokens['secret']
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    if user = User.find_by_email(data["email"])
      # user.fb_oauth_token = access_token['credentials']['token']
      user
    # elsif signed_in_resource
    #   signed_in_resource.fb_oauth_token = access_token['credentials']['token']
    #   signed_in_resource.fb_oauth_secret = access_token['credentials']['secret']
    #   signed_in_resource.save
    else # Create a user with a stub password. 
      u = User.create(:email => data["email"], 
        :password => Devise.friendly_token[0,20])
      u.fb_oauth_token = access_token['credentials']['token']
      u.save
      u
    end
  end

  def self.find_for_twitter_oauth(access_token, signed_in_resource=nil)
    id = access_token['uid']
    nick = access_token['user_info']['nickname'] if access_token['user_info']
    if user = User.find_by_uid(id)
      # if signed_in_resource and signed_in_resource.id != user.id
      #   redirect_to :root, :notice => "This account have been already registered."
      # else
        user
      # end
    # elsif signed_in_resource and signed_in_resource.uid.blank?
    #   signed_in_resource.uid = id
    #   signed_in_resource.oauth_token = access_token['credentials']['token']
    #   signed_in_resource.oauth_secret = access_token['credentials']['secret']
    #   signed_in_resource.save
    else
      User.create(:username => nick, :password => Devise.friendly_token[0,20], :uid => id) 
    end
  end

  def link_twitter(access_token)
    self.uid = access_token['uid']
    self.oauth_token = access_token['credentials']['token']
    self.oauth_secret = access_token['credentials']['secret']
    self.save
  end

  def link_facebook(access_token)
    self.fb_oauth_token = access_token['credentials']['token']
    self.save
  end
end

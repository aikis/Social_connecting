class RegistrationsController < Devise::RegistrationsController
  def create
    super
    # session["devise.twitter_data"] = nil unless @user.new_record?
    # session["oauth"] = nil unless @user.new_record?
  end
  
  private
  
  def build_resource(*args)
    super
    if session["devise.twitter_data"]
      @user.apply_omniauth_twitter(session["devise.twitter_data"], session["devise.oauth"])
      @user.valid?
    end
    if session["devise.facebook_data"]
      @user.apply_omniauth_facebook(session["devise.facebook_data"], session["devise.oauth"])
      @user.valid?
    end
  end
end
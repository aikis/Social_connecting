class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model
    @user = User.find_for_facebook_oauth(env["omniauth.auth"], current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = env["omniauth.auth"]
      session["devise.oauth"] = env["omniauth.auth"]['credentials']
      redirect_to new_user_registration_url
    end
  end

  def twitter
    # You need to implement the method below in your model
    @user = User.find_for_twitter_oauth(env["omniauth.auth"], current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"
      if current_user
        redirect_to :root
      else
        sign_in_and_redirect @user, :event => :authentication
      end
    else
      session["devise.twitter_data"] = env["omniauth.auth"]['extra']['user_hash']
      session["devise.oauth"] = env["omniauth.auth"]['credentials']
      redirect_to new_user_registration_url
    end
  end
end
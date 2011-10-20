class HomeController < ApplicationController
  def index
    if user_signed_in? && current_user.oauth_token
      session['client'] = Twitter::Client.new(:oauth_access => {
          :key => current_user.oauth_token, :secret => current_user.oauth_secret
        })
    end
  end
end
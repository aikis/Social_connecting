class HomeController < ApplicationController
  def index
  end

  def twitme
    if user_signed_in?
      # if current_user.oauth_token
      #   session['client'] = Twitter::Client.new(:oauth_access => {
      #       :key => current_user.oauth_token, :secret => current_user.oauth_secret
      #     }
      #   )
      #   session['client'].status :post, "This is a test!"
      # end
      if current_user.fb_oauth_token
        me = FbGraph::User.me(current_user.fb_oauth_token)
        me.feed!(
          :message => 'Updating via FbGraph',
          :picture => 'https://graph.facebook.com/matake/picture',
          :link => 'https://github.com/nov/fb_graph',
          :name => 'FbGraph',
          :description => 'A Ruby wrapper for Facebook Graph API'
        )
      end
    end
  end

  def fbme
  end
end
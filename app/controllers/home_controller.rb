class HomeController < ApplicationController
  def index
    # if current_user
    #   fbme
    #   twitme
    # end
  end

  def twitme
    if current_user.oauth_token
      if current_user.oauth_token
        session['client'] = Twitter::Client.new(:oauth_access => {
            :key => current_user.oauth_token, :secret => current_user.oauth_secret
          }
        )
        session['client'].status :post, "This is a test!"
      end
    end
  end

  def fbme
    if current_user.fb_oauth_token
      begin
        me = FbGraph::User.me(current_user.fb_oauth_token)
        me.fetch
        me.feed!(
          :message => 'Updating via FbGraph',
          :link => 'https://github.com/nov/fb_graph',
          :name => 'FbGraph',
          :description => 'A Ruby wrapper for Facebook Graph API'
        )
        # me.fetch
        # threads = me.threads
        # @msg = threads.first.messages
      rescue FbGraph::InvalidSession
        current_user.fb_oauth_token = nil
        current_user.save
        redirect_to :root, :noticw => "Facebook error. Please re-login in Facebook!"
      end
    end
  end
end
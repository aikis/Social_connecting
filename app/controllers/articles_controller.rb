class ArticlesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  def new
  end

  def index
    @articles = Article.all
  end

  def create
    article = Article.new(:title => params[:title], :text => params[:text], :uid => current_user.id)
    article.save
    if params[:twitter]
      twi = Twitter::Client.new(:oauth_access => {
            :key => current_user.oauth_token, :secret => current_user.oauth_secret
          }
        )
      twi.status :post, "I've add a new article: #{article.title}"
    end
    if params[:facebook]
      me = FbGraph::User.me(current_user.fb_oauth_token).fetch
      me.feed!(
        :message => "I've add a new article: #{article.title}",
        :link => 'https://github.com/nov/fb_graph',
        :name => 'FbGraph',
        :description => 'A Ruby wrapper for Facebook Graph API'
      )
    end
    redirect_to :root, :notice => "Successfully saved!"
  end
end

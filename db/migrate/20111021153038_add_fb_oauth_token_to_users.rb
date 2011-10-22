class AddFbOauthTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fb_oauth_token, :string
  end
end

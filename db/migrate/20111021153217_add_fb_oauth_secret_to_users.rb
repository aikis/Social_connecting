class AddFbOauthSecretToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fb_oauth_secret, :string
  end
end

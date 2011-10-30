class AddUidToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :uid, :integer
  end
end

class AddCommentsOpenToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :comments_open, :boolean, :default => true
  end
  
  def self.down
    remove_column :posts, :comments_open
  end
end
class AddEmailNameAndUrlToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :email, :string
    add_column :users, :name, :string
    add_column :users, :url, :string
  end
  
  def self.down
    remove_column :users, :email
    remove_column :users, :url
    remove_column :users, :name
  end
end

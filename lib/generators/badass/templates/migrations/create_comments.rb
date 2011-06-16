class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :post_id, :null => false
      t.string :author
      t.string :author_url
      t.string :author_email
      t.string :comment_type, :default => 'comment'
      t.text :content
      t.string :user_ip
      t.string :user_agent
      t.string :referrer
      t.boolean :junk, :default => false
      t.timestamps
    end
  end
  
  def self.down
    drop_table :comments
  end
end

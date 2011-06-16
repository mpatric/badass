class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :user_id, :null => false
      t.string  :title_draft, :null => false
      t.string  :title
      t.text :content_draft
      t.text :content
      t.integer :version_draft, :default => 1
      t.integer :version
      t.date :date
      t.datetime :first_published_at
      t.datetime :last_published_at
      t.string :permalink
      t.timestamps
    end
  end
  
  def self.down
    drop_table :posts
  end
end

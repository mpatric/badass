module Badass
  class MigrationsGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    
    source_root File.expand_path('../templates/migrations', __FILE__)
    
    def generate_migrations
      copy_file 'seeds.rb', 'db/seeds.rb'
      generate_migration('create_users')
      generate_migration('create_session')
      generate_migration('add_email_name_and_url_to_users')
      generate_migration('create_posts')
      generate_migration('create_comments')
      generate_migration('create_assets')
      generate_migration('create_tags')
      generate_migration('create_posts_tags')
    end
    
    private
    
      def generate_migration(name)
        begin
          migration_template "#{name}.rb", "db/migrate/#{name}.rb"
          sleep 1 # so next migration will have a different timestamp
        rescue
          puts "Skipping migration: #{name}"
        end
      end
    
      # interface for Rails::Generators::Migration.
      def self.next_migration_number(dirname) #:nodoc:
        if ActiveRecord::Base.timestamped_migrations
          Time.now.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end
  end
end

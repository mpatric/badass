# delete unnecessary files
# run "rm public/index.html"
# run "rm app/views/layouts/application.html.erb"
# run "rm public/favicon.ico"
# run "rm public/images/rails.png"
# run "rm public/javascripts/application.js"

# create gemfile
run "rm Gemfile"
file "Gemfile", <<-END
source 'http://rubygems.org'

gem 'badass', :git => 'git@github.com:mpatric/badass.git', :branch => 'master'

# For development use local repo
# gem 'badass', :path => '../badass'
END

# bundle
run "bundle"

# Commands
# run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
# run 'wheneverize .'

# capify
# run 'capify .'
# run 'rm config/deploy.rb'

run 'rm .gitignore'

# create git ignore file
file '.gitignore', <<-END
.DS_Store
.bundle
log/*.log
tmp/**/*
db/*.sqlite3
db/schema.rb
log/*.pid
public/system/**/*
public/stylesheets/*.css
*.tmproj
tmtags
*~
\#*
.\#*
*.swp
rdoc
pkg
END

say 'Now run: rails generate badass'
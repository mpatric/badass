# Badass

A [Rails](http://rubyonrails.org/) engine for building blogging applications. It  is what drives my personal blog at [mpatric.com](http://mpatric.com/).

Some features:

-   Admin interface, with support for (unpublished) draft posts and draft versions
-   Anti-spam protection on comments via [Akismet](http://akismet.com/)
-   Assets stored on [Amazon S3](http://aws.amazon.com/s3/)
-   Avatars on comments pulled from [Gravatar](http://gravatar.com/)
-   Apps built with this engine can easily be hosted on [Heroku](http://www.heroku.com/)
-   Email notifications
-   Atom feeds for posts and comments
-   Highly customisable


## Acknowledgements

This app makes use of [MarkItUp](http://markitup.jaysalvat.com/).

## Copyright

Copyright (c) 2011 Michael Patricios. See mit-license.txt for details.


# How to generate a blog using this engine

Create a new rails app:

    rails new badass-demo

Edit the gemfile and add the badass gem:

    gem 'badass', :git => 'git://github.com/mpatric/badass.git', :branch => 'master'

Make sure you have bundler installed (with sudo if you're not using rvm):

    gem install bundler

Run bundler:

    bundle

Run the badass generator:

    rails g badass:site -f

Update database.yml as appropriate, then create your database and run the migrations:

    rake db:create
    rake db:migrate

If you wish to generate some test data, run:

    rake db:seed

Start rails locally:

    rails s

Go to http://localhost:3000/admin with your web browser for the admin interface, if you've generated test data login with test/test

Go to http://localhost:3000/ with your web browser for the blog

# Customising the app

## Configuration

Edit the configuration file config/badass.yml. The keys are fairly self-explanatory. If you want to use Akismet for spam protection you will need to register at [akismet.com](http://akismet.com/) and get an API key. If you want to track analytics with google analytics you will need your analytics account id (the number starting 'UA-').

Edit the Amazon s3 configuration in config/s3.yml to include your access key id and secret access key. You will need to sign up for Amazon web services to use this. You won't be able to upload assets to your blog without setting up s3 support.

You should probably add password_confirmation to the list of filtered parameters in config/application.rb:

    config.filter_parameters += [:password, :password_confirmation]

If you are setting up a personal blog, you'll probably want to leave max_users for production in badass.yml on 1, which means as soon as you register yourself it won't be possible for other people to register on your site. If you're setting up a blog for multiple people to use, you might want to increase this number.

## Views

If you want some information to appear on the top-right of the page (typically information about yourself), edit the partial /app/views/home/_about.html.erb

You can replace any of the views provided by the engine by providing the same view in your app. The easiest way to do this is to copy a view from the app/views folder in the badass gem to the same path in your project, then edit yours.

## Styles

You are provided with three [sass](http://sass-lang.com/) stylesheets in public/stylesheets/sass:

-   admin.sass - styles for the admin interface
-   site.sass - styles for the public blog site
-   content.sass - styles for the content, primarily for the public blog site, but also used in the admin interface for previewing posts

Each of these stylesheets pulls in the default styles from the badass gem. You can easily over-ride any of the styles in the application by entering styles into these three stylesheets. Do not remove the import statements at the start of each stylesheet, or you will lose all the default styling.

## Setting up email support

As of version 0.2, the author of a post can get email notifications when comments are made to their posts. In order to enable this functionality, ensure these two keys are set in your badass.yml file (with an appropriate email address):

    email_enabled: true
    email_sender: 'noreply@mydomain.com'

Then make sure you set up the smtp settings for action mailer (usually in config/environment/production.rb). If you are using gmail, these are the settings:

    config.action_mailer.smtp_settings[:address] = 'smtp.gmail.com'
    config.action_mailer.smtp_settings[:port] = 587
    config.action_mailer.smtp_settings[:domain] = ('gmail.com' or your domain if you have a custom gmail domain)
    config.action_mailer.smtp_settings[:user_name] = (full username, e.g. 'myname@gmail.com' or 'myname@mydomain.com')
    config.action_mailer.smtp_settings[:password] = (password)
    config.action_mailer.smtp_settings[:authentication] = 'plain'
    config.action_mailer.smtp_settings[:enable_starttls_auto] = true

# Updating your app to the latest version of badass

Update your gems with bundler:

    bundle update

It is strongly recommended that the generator is re-run whenever the badass gem is updated, as files generated with the site generator may have changed too. Run:

    rails g badass:site -s

That will re-run the site generator, but skip the files you have modified so they don't get over-written. If any new migrations are generated by this you will need to run the migrations:

    rake db:migrate

# The TODO list

Things that might be added in the future:

-   More semantic markup
-   Auto sitemap generation
-   Additional 'themes' out of the box
-   Validate email address on comment entry
-   Caching
-   Better Twitter integration: tweet this post, with tweet count
-   Trackbacks
-   Pingbacks
-   Email followup comments to other commenters, with unsubscribe functionality

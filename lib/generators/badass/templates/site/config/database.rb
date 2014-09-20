development:
  adapter: postgresql
  host: localhost
  database: <%= @name %>_development
  username: root
  encoding: utf8

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
  adapter: postgresql
  host: localhost
  database: <%= @name %>_test
  username: root
  encoding: utf8

production:
  adapter: postgresql
  host: localhost
  database: <%= @name %>_production
  username: root
  encoding: utf8

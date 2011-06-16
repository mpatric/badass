development:
  adapter: mysql2
  database: <%= @name %>_development
  encoding: utf8
  reconnect: false
  pool: 5
  socket: /tmp/mysql.sock
  username: root
  password:

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
  adapter: mysql2
  database: <%= @name %>_test
  encoding: utf8
  reconnect: false
  pool: 5
  socket: /tmp/mysql.sock
  username: root
  password:

production:
  adapter: mysql2
  database: <%= @name %>_production
  encoding: utf8
  reconnect: true
  pool: 5
  username: root
  password:

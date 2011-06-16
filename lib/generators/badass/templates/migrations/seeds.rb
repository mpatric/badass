# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

ipsum = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
broken_ipsum = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.~ Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'

user = User.create!(:login => 'test', :password => 'test', :password_confirmation => 'test', :email => 'admin@test.test', :name => 'Test User', :url => 'http://www.google.com/')

posts = []
posts << Post.create!(:user => user, :title_draft => 'My first post', :content_draft => broken_ipsum, :date => Date.civil(2009, 7, 26))
posts << Post.create!(:user => user, :title_draft => 'My second post', :content_draft => ipsum, :date => Date.civil(2009, 8, 1))
posts << Post.create!(:user => user, :title_draft => 'Another post', :content_draft => broken_ipsum, :date => Date.civil(2009, 9, 30))
posts << Post.create!(:user => user, :title_draft => 'Yet another post, with a long title', :content_draft => ipsum, :date => Date.civil(2009, 10, 1))
posts << Post.create!(:user => user, :title_draft => 'The fifth post', :content_draft => broken_ipsum, :date => Date.civil(2009, 10, 10))
posts << Post.create!(:user => user, :title_draft => 'the sixth post', :content_draft => ipsum, :date => Date.civil(2009, 12, 31))
posts << Post.create!(:user => user, :title_draft => 'Number 7', :content_draft => ipsum, :date => Date.civil(2010, 1, 1))
posts << Post.create!(:user => user, :title_draft => 'Eight', :content_draft => broken_ipsum, :date => Date.civil(2010, 2, 28))
posts << Post.create!(:user => user, :title_draft => 'Nine, it is', :content_draft => ipsum, :date => Date.civil(2010, 3, 1))
posts << Post.create!(:user => user, :title_draft => 'TEN', :content_draft => broken_ipsum, :date => Date.civil(2010, 4, 14))
posts << Post.create!(:user => user, :title_draft => 'Eleven', :content_draft => ipsum, :date => Date.civil(2010, 5, 14))
posts << Post.create!(:user => user, :title_draft => 'My twelfth post', :content_draft => ipsum, :date => Date.civil(2010, 10, 26))
posts << Post.create!(:user => user, :title_draft => 'Unlucky for some..', :content_draft => broken_ipsum, :date => Date.civil(2010, 11, 9))
posts << Post.create!(:user => user, :title_draft => 'Fourteenth', :content_draft => broken_ipsum, :date => Date.civil(2010, 11, 10))
posts << Post.create!(:user => user, :title_draft => 'My fifteenth post', :content_draft => broken_ipsum, :date => Date.civil(2010, 11, 10))

[0,1,3,4,5,6,9,10,11,12].each do |i|
  posts[i].publish!
  posts[i].save
end

[0,3,5,6,9,11,12].each do |i|
  posts[i].comments.create!(:author => 'Fitzroy', :author_email => 'fitzroy@test.test', :author_url => 'http://www.google.co.uk/', :content => 'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur!')
  posts[i].comments.create!(:author => 'Elmo', :author_email => 'elmo@test.test', :author_url => 'http://www.google.co.uk/', :content => 'Quis nostrud exercitation ullamco laboris nisi? Duis aute irure dolor in reprehenderit in voluptate velit esse cillum! Eesse cillum!')
  posts[i].comments.create!(:author => 'Fitzroy', :author_email => 'fitzroy@test.test', :author_url => 'http://www.google.co.uk/', :content => 'Laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit.')
end

Tag.create!(:label => 'General', :posts => [posts[0], posts[1], posts[2], posts[6], posts[7], posts[8], posts[11], posts[12]])
Tag.create!(:label => 'Fluff')
Tag.create!(:label => 'Technology', :posts => [posts[0], posts[3], posts[6], posts[9], posts[12]])
Tag.create!(:label => 'iPhone', :posts => [posts[0], posts[2], posts[4], posts[6], posts[8], posts[10], posts[12]])
Tag.create!(:label => 'Gaming', :posts => [posts[0], posts[1], posts[3], posts[5], posts[7], posts[9]])
Tag.create!(:label => 'Sport')
Tag.create!(:label => 'Education', :posts => [posts[0], posts[5], posts[10]])

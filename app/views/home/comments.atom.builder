atom_feed(:schema_date => 2009, :root_url => root_url, :url => '/comments.atom') do |feed|
  feed.title "#{APP_CONFIG.blog_title} - Comments Feed" unless @post
  feed.title "#{APP_CONFIG.blog_title} - #{@post.title} - Comments Feed" if @post
  feed.updated @comments.first.updated_at
  for comment in @comments
    feed.entry(comment, :url => File.join(APP_CONFIG.domain, comment.permalink_url)) do |entry|
      entry.title comment.post.title
      entry.updated comment.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")
      entry.author do |author|
        author.name comment.author
        author.url comment.author_url if comment.author_url
      end
      entry.content comment.content_html, :type => 'html'
    end
  end
end
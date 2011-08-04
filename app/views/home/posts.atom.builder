atom_feed(:schema_date => 2009, :root_url => root_url, :url => '/posts.atom') do |feed|
  feed.title "#{APP_CONFIG.blog_title} - Posts Feed" unless @tag
  feed.title "#{APP_CONFIG.blog_title} - #{@tag.label} - Posts Feed" if @tag
  feed.updated @posts.first.updated_at
  for post in @posts
    feed.entry(post, {:url => post.full_permalink_url, :published => post.first_published_at, :updated => post.updated_at}) do |entry|
      entry.title post.title
      entry.author do |author|
        author.name post.user.name
        author.url post.user.url
      end
      entry.summary post.content_short_html(" [...]"), :type => 'html'
      entry.content post.content_html, :type => 'html'
      post.tags.each do |tag|
        entry.category tag.label
      end
    end
  end
end
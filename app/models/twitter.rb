require 'ostruct'

class Twitter
  include Singleton

  def tweets
    return nil unless APP_CONFIG.twitter_enabled
    if @tweets.nil? or @last_download.nil? or (Time.now - APP_CONFIG.twitter_cache_time.seconds > @last_download)
      download_tweets
    end
    @tweets
  end

  private
    def download_tweets
      begin
        client = Grackle::Client.new
        User.has_twitter_name.each do |user|
          tweets = client.statuses.user_timeline? :screen_name => user.twitter_name
          @tweets = []
          tweets.each do |tweet|
            @tweets << OpenStruct.new({
              :name => user.twitter_name,
              :user_url => user.twitter_url,
              :text => (link_hashtags(link_urls(tweet.text))).html_safe,
              :url => "http://twitter.com/#{user.twitter_name}/statuses/#{tweet.id_str}",
              :reply_url => "http://twitter.com/?status=@#{user.twitter_name}&in_reply_to_status_id=#{tweet.id_str}&in_reply_to=#{user.twitter_name}",
              :timestamp => Time.parse(tweet.created_at)})
          end
        end
        @last_download = Time.now
        @tweets = @tweets.sort_by{ |t| -t.timestamp }.reverse
      rescue
      end
    end

    def link_urls(s)
      s.scan(/http:\/\/[^\s]+/).uniq.each do |url|
        s.gsub!(url, "<a href='#{url}'>#{url}</a>")
      end
      s
    end

    def link_hashtags(s)
      s.scan(/\s#\w+/).uniq.each do |hashtag|
        s.gsub!(hashtag, " <a href='http://twitter.com/search?q=#{CGI::escape(hashtag.strip)}'>#{hashtag.strip}</a>")
      end
      s
    end
end

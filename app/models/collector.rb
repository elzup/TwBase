class Collector
  def initialize
    @client = InfTwitterClient.new
  end

  def inf_get(word)
    while 1
      old_tw = Tweet.where(:search_word => word).order(:tweeted_at).first
      @client.reload_client
      puts "#{@client.rate_limit_search_s} >>"
      # よく規制かかるので API limit の半分
      count = [0, @client.rate_limit_search[:remaining] * 50].max
      # count = 50
      res = @client.dig_search(word, old_tw).take(count)
      if res.count == 0
        break
      end
      tweets = []
      res.each_slice(1000).with_index do |tws, i|
        tws.each do |tw|
          # regist user
          user = User.find_or_create_by(tid: tw.user.id) do |user|
            user.screen_name = tw.user.screen_name
          end
          # regist tweet
          tweets << Tweet.new(
              user_id: user.id,
              tweet_id: tw.id,
              text: tw.text,
              search_word: word,
              tweeted_at: tw.created_at
          )
        end
        puts "#{i}: #{tweets.last.tweeted_at}"
      end
      Tweet.import tweets
      puts "get #{res.count} tweet"
      puts ">> #{@client.rate_limit_search_s}"
    end
  end

  def inf_get_geo(lat, long, r)
    while 1
      old_tw = Tweet.where(:search_word => 'geo').order(:tweeted_at).first
      @client.reload_client
      puts "#{@client.rate_limit_search_s} >>"
      # よく規制かかるので API limit の半分
      count = [0, @client.rate_limit_search[:remaining] * 50].max
      count = 180
      res = @client.geo_search(lat, long, r, old_tw).take(count)
      tweets = []
      res.each_slice(1000).with_index do |tws, i|
        tws.each do |tw|
          # regist user
          user = User.find_or_create_by(tid: tw.user.id) do |user|
            user.screen_name = tw.user.screen_name
          end
          # regist tweet
          tweet = Tweet.find_by(tweet_id: tw.id)
          if tweet
            tweet.lat = tw.geo.lat
            tweet.long = tw.geo.long
            tweet.save
            next
          end
          tweets << Tweet.new(
              user_id: user.id,
              text: tw.text,
              tweeted_at: tw.created_at,
              lat: tw.geo.lat,
              long: tw.geo.long
          )
        end
      end
      Tweet.import tweets
      puts "#{i}: #{tweets.last.tweeted_at}"
    end
  end
end

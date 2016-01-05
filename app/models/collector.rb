class Collector
  def initialize
    @client = InfTwitterClient.new
  end

  def inf_get(word)
    while 1
      old_tw = Tweet.where(:search_word => word).order(:tweeted_at).first
      client.reload_client
      puts "#{client.rate_limit_search_s} >>"
      # よく規制かかるので API limit の半分
      count = [0, client.rate_limit_search[:remaining] * 50].max
      # count = 50
      res = client.dig_search(word, old_tw).take(count)
      # res = client.dig_search(word, old_tw).take(180)
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
        Tweet.import tweets
        puts "#{i}: #{tweets.last.tweeted_at}"
      end
      puts "get #{res.count} tweet"
      puts ">> #{client.rate_limit_search_s}"
    end
  end
end

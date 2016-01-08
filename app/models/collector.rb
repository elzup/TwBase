class Collector
  def initialize
    @client = InfTwitterClient.new
  end

  def print_graph_all
    print_graph(Tweet.hour_count)
  end

  def print_graph_word(word)
    print_graph(Tweet.hour_count_word(word))
  end

  def print_graph_geo
    print_graph(Tweet.hour_count_geo)
  end

  def print_graph_4sq
    print_graph_word('4sq')
  end

  def print_graph_going
    print_graph_word('行く')
  end

  def print_graph(data)
    data.each do |date, counts|
      puts " [#{date}]"
      counts.each_with_index do |count, h|
        puts ('%02d: %8d' % [h, count]) + '=' * [Math.log2(count), 0].max.to_i
      end
    end
    # end
  end

  def inf_get(word)
    while 1
      old_tw = Tweet.where(:search_word => word).oldest
      @client.reload_client
      puts "#{@client.rate_limit_search_s} >>"
      res = @client.dig_search(word, old_tw).take(@client.dig_limit)
      break if res.count == 0
      tweets = []
      res.each_slice(1000).with_index do |tws, i|
        tws.each do |tw|
          user = User.regist(tw.user.id, tw.user.screen_name)
          tweets << Tweet.new_tw(user, tw, word)
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
      old_tw = Tweet.geo.oldest
      @client.reload_client
      puts "#{@client.rate_limit_search_s} >>"
      res = @client.geo_search(lat, long, r, old_tw).take(@client.dig_limit)
      break if res.count == 0
      tweets = []
      res.each_slice(1000).with_index do |tws, i|
        tws.each do |tw|
          user = User.regist(tw.user.id, tw.user.screen_name)
          tweets << Tweet.new_geo(user, tw)
        end
        puts "#{i}: #{tweets.last.tweeted_at}"
      end
      Tweet.import tweets
      puts "get #{res.count} tweet"
      puts ">> #{@client.rate_limit_search_s}"
    end
  end

  def inf_4sq
    while 1
      old_tw = Tweet.where(:search_word => '4sq').oldest
      @client.reload_client
      puts "#{@client.rate_limit_search_s} >>"
      res = @client.search_4sq(old_tw).take(@client.dig_limit)
      break if res.count == 0
      tweets = []
      res.each_slice(1000).with_index do |tws, i|
        tws.each do |tw|
          user = User.regist(tw.user.id, tw.user.screen_name)
          tweets << Tweet.new_4sq(user, tw)
        end
        puts "#{i}: #{tweets.last.tweeted_at}"
      end
      Tweet.import tweets
      puts "get #{res.count} tweet"
      puts ">> #{@client.rate_limit_search_s}"
    end
  end
end

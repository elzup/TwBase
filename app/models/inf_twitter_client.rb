class InfTwitterClient
  def initialize
    setup_app_token(Rails.application.secrets.twitter['aoa_keys'])
  end

  ### module ###
  def check_clients
    @tokens.count.times do
      reload_client
      print_client_info
    end
  end

  def reload_client
    token = next_token
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = token.consumer_key
      config.consumer_secret = token.consumer_secret
    end
  end

  ### request method ###
  def dig_search(q, old_tw)
    @client.search(
        q,
        exclude: 'retweets',       # RT排除
        result_type: 'recent',
        count: 100,
        max_id: old_tw && old_tw.tweet_id.to_i - 1
    )
  end

  def geo_search(lat, long, r, old_tw)
    @client.search(
        '',
        geocode: "#{lat},#{long},#{r}",
        exclude: 'retweets',              # RT排除
        result_type: 'recent',
        count: 100,
        max_id: old_tw && old_tw.tweet_id.to_i - 1
    )
  end

  def search_4sq(old_tw)
    @client.search(
        'swarmapp.com/c/',
        exclude: 'retweets',       # RT排除
        result_type: 'recent',
        filter: 'links',
        count: 100,
        max_id: old_tw && old_tw.tweet_id.to_i - 1
    )
  end

  def dig_limit
    # よく規制かかるので API limit の半分
    [0, @client.rate_limit_search[:remaining] * 50].max
  end

  def rate_limit_search_s
    limit = rate_limit_search
    "[#{limit[:remaining]}/#{limit[:limit]}]"
  end

  def rate_limit_search
    res = Twitter::REST::Request.new(@client, :get, '/1.1/application/rate_limit_status.json').perform
    res[:resources][:search][:'/search/tweets']
  end

  private
  def print_client_info
    search_limit = rate_limit_search
    puts "OK [#{search_limit[:remaining]}/#{search_limit[:limit]}]"
  end

  def setup_app_token(tokens_s)
    @tokens = parse_app_token(tokens_s)
    @token_iterator = Enumerator.new do |y|
      while true
        @tokens.each do |token|
          y << token
        end
      end
    end
  end

  def parse_app_token(tokens_s)
    tokens_s.split(':').each_slice(2).map do |ts|
      TwitterAppToken.new(ts[0], ts[1])
    end
  end

  def next_token
    @token_iterator.next
  end

  class TwitterAppToken
    attr_reader :consumer_key, :consumer_secret

    def initialize(consumer_key, consumer_secret)
      @consumer_key = consumer_key
      @consumer_secret = consumer_secret
    end
  end
end

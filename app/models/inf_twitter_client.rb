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

  def dig_refresh
  end

  ### request method ###
  def dig_search(q)
    reload_client
    res = @client.search(
        q,
        exclude: 'retweets',       # RT排除
        result_type: 'recent',
        count: 100,
    )
    res.take(18000)
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

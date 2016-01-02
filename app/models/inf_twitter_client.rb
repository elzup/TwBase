class InfTwitterClient
  def initialize
    setup_token(Rails.application.secrets.twitter['tokens'])
  end

  def check_clients
    @tokens.count.times do
      reload_client
      print_client_info
    end
  end

  def print_client_info
    unless @client.user_token?
      puts 'Faild'
      return
    end
    search_limit = rate_limit_search
    puts "@#{@client.user.screen_name} [#{search_limit[:remaining]}/#{search_limit[:limit]}]"
  end

  def rate_limit_search
    res = Twitter::REST::Request.new(@client, :get, '/1.1/application/rate_limit_status.json').perform
    res[:resources][:search][:'/search/tweets']
  end

  def reload_client
    token = next_token
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = token.consumer_key
      config.consumer_secret     = token.consumer_secret
      config.access_token        = token.token_key
      config.access_token_secret = token.token_secret
    end
  end

  def setup_token(tokens_s)
    @tokens = parse_token(tokens_s)
    @token_iterator = Enumerator.new do |y|
      while true
        @tokens.each do |token|
          y << token
        end
      end
    end
  end

  def parse_token(tokens_s)
    tokens_s.split(':').each_slice(4).map do |ts|
      TwitterToken.new(ts[0], ts[1], ts[2], ts[3])
    end
  end

  def next_token
    @token_iterator.next
  end

  class TwitterToken
    attr_reader :consumer_key, :consumer_secret, :token_key, :token_secret
    def initialize(consumer_key, consumer_secret, token_key, token_secret)
      @consumer_key = consumer_key
      @consumer_secret = consumer_secret
      @token_key = token_key
      @token_secret = token_secret
    end
  end
end

class InfTwitterClient
  def initialize
    setup_token(Rails.application.secrets.twitter['tokens'])
  end

  def load_client
  end

  def check_clients
    reload_client
    # binding.pry
    @client.perform
  end

  def reload_client
    token = @next_token
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = token.consumer_key
      config.consumer_secret     = token.consumer_secret
      config.access_token        = token.access_key
      config.access_token_secret = token.access_secret
    end
  end

  def setup_token(tokens_s)
    @tokens = parse_token(tokens_s)
    @next_token = Enumerator.new do |y|
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
    @next_token.next
  end

  class TwitterToken
    def initialize(consumer_key, consumer_secret, token_key, token_secret)
      @consumer_key = consumer_key
      @consumer_secret = consumer_secret
      @token_key = token_key
      @token_secret = token_secret
    end
  end
end

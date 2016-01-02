class InfTwitterClient
  def initialize
    setup_token(Rails.application.secrets.twitter['tokens'])
    # client =
  end

  def setup_token(tokens_s)
    self.tokens = parse_token(tokens_s)
  end
end

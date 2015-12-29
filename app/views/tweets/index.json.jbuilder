json.array!(@tweets) do |tweet|
  json.extract! tweet, :id, :tweet_id, :text, :user_id
  json.url tweet_url(tweet, format: :json)
end

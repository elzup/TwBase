json.array!(@users) do |user|
  json.extract! user, :id, :twitter_id, :twitter_screen_name
  json.url user_url(user, format: :json)
end

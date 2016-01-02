namespace :collector do
  desc 'トークンが有効か確認'
  task check_token: :environment do
    client = InfTwitterClient.new
    client.check_clients
  end

  desc '「行く, 向かう」キーワード取得'
  task search_going: :environment do
    q = '行く OR 向かう'
    client = InfTwitterClient.new
    old_tw = Tweet.where(:search_word => q).order(:tweeted_at).first
    res = client.dig_search(q, old_tw).take(10000)
    puts "#{client.rate_limit_search_s} >>"
    res.each_with_index do |tw, i|
      # regist user
      user = User.find_or_create_by(
          tid: tw.user.id,
          screen_name: tw.user.screen_name
      )
      # regist tweet
      tweet = Tweet.find_or_create_by(
          user_id: user.id,
          tweet_id: tw.id,
          text: tw.text,
          search_word: q,
          tweeted_at: tw.created_at
      )
      if i % 100 == 0
        puts "#{i}: #{tw.created_at}"
      end
    end
    puts "get #{res.count} tweet"
    puts ">> #{client.rate_limit_search_s}"
  end

end

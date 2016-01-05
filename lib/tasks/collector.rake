namespace :collector do
  desc 'トークンが有効か確認'
  task check_token: :environment do
    client = InfTwitterClient.new
    client.check_clients
  end

  desc '「行く」キーワード取得'
  task search_going: :environment do
    q = '行く'
    client = InfTwitterClient.new
    while 1
      old_tw = Tweet.where(:search_word => q).order(:tweeted_at).first
      client.reload_client
      puts "#{client.rate_limit_search_s} >>"
      # よく規制かかるので API limit の半分
      count = [0, client.rate_limit_search[:remaining] * 50].max
      # count = 50
      res = client.dig_search(q, old_tw).take(count)
      # res = client.dig_search(q, old_tw).take(180)
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
              search_word: q,
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

  desc '日時別ツイート数'
  task :counts_day, ['word'] => :environment do |task, args|
    Tweet.day_count(args['word'])
  end
end

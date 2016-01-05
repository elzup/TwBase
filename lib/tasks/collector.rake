namespace :collector do
  desc 'トークンが有効か確認'
  task check_token: :environment do
    client = InfTwitterClient.new
    client.check_clients
  end

  desc '「行く」キーワード取得'
  task search_going: :environment do
    q = '行く'
    collector = Collector.new
    collector.inf_get q
  end

  desc '日本の geo ツイート取得'
  task search_geo: :environment do
    lat = 35.70902
    long = 139.73199
    r = '1000km'
    collector = Collector.new
    collector.inf_get_geo(lat, long, r)
  end

  desc '日時別ツイート数'
  task :counts_day, ['word'] => :environment do |task, args|
    Tweet.day_count(args['word']).each do |date, count|
      puts "#{date} - #{count} tweets"
    end
  end
end

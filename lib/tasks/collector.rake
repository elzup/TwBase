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

  desc 'foursquare ツイート取得'
  task search_4sq: :environment do
    collector = Collector.new
    collector.inf_4sq
  end

  desc '日時別ツイート数'
  task :counts_day => :environment do
    Tweet.day_count.each do |date, count|
      puts "#{date} - #{count} tweets"
    end
  end

  desc '日時別ツイート数詳細'
  task :counts_hour => :environment do
    Tweet.hour_count.each do |date, counts|
      puts " [#{date}]"
      counts.each_with_index do |count, h|
        puts ('%02d: %8d' % [h, count]) + '=' * [Math.log2(count), 0].max.to_i
      end
    end
    # end
  end

  desc '日時別ツイート数詳細 geo'
  task :counts_hour_geo => :environment do
    Tweet.hour_count_geo.each do |date, counts|
      puts " [#{date}]"
      counts.each_with_index do |count, h|
        puts ('%02d: %8d' % [h, count]) + '=' * [Math.log2(count), 0].max.to_i
      end
    end
    # end
  end
end

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

  desc 'Look each first, last'
  task :data_term => :environment do
    collector = Collector.new
    collector.print_data_points
  end

  desc '日別ツイート数'
  task :counts_day => :environment do
    Tweet.day_count.each do |date, count|
      puts "#{date} - #{count} tweets"
    end
  end

  desc '時間別ツイート数 all'
  task :counts_hour_all => :environment do
    collector = Collector.new
    collector.print_graph_all
  end

  desc '時間別ツイート数 going'
  task :counts_hour_going => :environment do
    collector = Collector.new
    collector.print_graph_going
  end

  desc '時間別ツイート数 geo'
  task :counts_hour_geo => :environment do
    collector = Collector.new
    collector.print_graph_geo
  end

  desc '時間別ツイート数 4sq'
  task :counts_hour_geo => :environment do
    collector = Collector.new
    collector.print_graph_4sq
  end
end

namespace :analysis do
  desc '行くの係り受け解析'
  task :parse_going => :environment do
    Tweet.going.limit(1000).each do |tweet|
      # text = '今からコミケの会場に行くわ'
      parser = Parser.new
      puts tweet.text
      # puts '>' + parser.where_go(text)
      target = parser.where_go(tweet.text)
      if target
        puts '> ' + parser.where_go(tweet.text)
      end
      puts '---'
    end
  end
end

namespace :analysis do
  desc '行くの係り受け解析'
  task :parse_going => :environment do
    i = 0
    a = Tweet.going.count
    tc = 0
    start_time = Time.now
    Tweet.going.find_each do |tweet|
      # text = '今からコミケの会場に行くわ'
      parser = Parser.new
      target = parser.where_go(tweet.text)
      if target
        tweet.text_keyword = last_word = target
        tweet.save
        tc += 1
      end
      i += 1
      if i % 1000 == 0
        printf("%#{a.to_s.length}d / %d [%.2f%%] <tc:%d (%.2f%%)>\t%s\t\t%ds\n",
               i,
               a,
               i * 100.0 / a,
               tc,
               tc * 100.0 / i,
               last_word,
               Time.now - start_time)
      end
    end
  end
end

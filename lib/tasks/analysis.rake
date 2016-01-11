namespace :analysis do
  desc '行くの係り受け解析'
  task :parse_going => :environment do
    text = '今からコミケの会場に行くわ'
    parser = Parser.new
    chunk = parser.where_go(text)
    binding.pry
  end
end

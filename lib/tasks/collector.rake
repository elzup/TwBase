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
    client.dig_search(q)
  end

end

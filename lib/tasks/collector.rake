namespace :collector do
  desc 'debug'
  task :check_token => :environment do
    client = InfTwitterClient.new
    client.check_clients
  end
end

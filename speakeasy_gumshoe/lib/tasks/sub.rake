task :subscribe => :environment do
  $redis.subscribe 'new_message' do |on|
    on.message do |channel, json_data|
      data = JSON.parse(json_data) rescue {}

      if data and data != {}
        QueryItem.create(:query => data['message'], :content => json_data)
        puts "Added new message to search! #{json_data}"
      end
    end
  end
end
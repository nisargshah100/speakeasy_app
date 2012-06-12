task :subscribe => :environment do
  $redis.subscribe 'messages' do |on|
    on.message do |channel, json_data|
      data = JSON.parse(json_data) rescue {}

      if data and data != {}
        CreatedMessage.create_from_on_tap(data)
      end
    end
  end
end

task :subscribe => :environment do
  $redis.subscribe('messages', 'rooms') do |on|
    on.message do |channel, json_data|
      data = JSON.parse(json_data) rescue {}

      if data and data != {}
        case channel
        when 'messages'
          CreatedMessage.create_from_on_tap(data)
        when 'rooms'
          CreatedRoom.create_from_on_tap(data)
        end
      end
    end
  end
end

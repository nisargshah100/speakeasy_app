task :subscribe => :environment do
  # $redis.subscribe 'new_message' do |on|
  #   on.message do |channel, json_data|
  #     data = JSON.parse(json_data) rescue {}

  #     if data and data != {}
  #       QueryItem.create(:query => data['message'], :content => json_data)
  #       puts "Added new message to search! #{json_data}"
  #     end
  #   end
  # end

  SpeakeasyOnTap::subscribe_to_channels(:created_messages) do |channel, data|
    if data and data != {}
      QueryItem.create(
        :query => data['body'], 
        :content => data.to_json,
        :ns => "[room]#{data['room_id']}")

      puts "Inserted #{data}"
    end
  end
end
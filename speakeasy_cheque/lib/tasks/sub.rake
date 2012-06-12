task :subscribe => :environment do
  CHANNELS = ['created_messages', 'created_rooms']

  SpeakeasyOnTap::subscribe_to_channels(CHANNELS) do |channel, data|
    channel.classify.constantize.create_from_on_tap(data)
  end
end

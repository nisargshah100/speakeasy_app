CreatedUser.destroy_all
CreatedRoom.destroy_all
CreatedMessage.destroy_all
CreatedPermission.destroy_all

#Create users

1000.times do |n|
  CreatedUser.create(created_at: DateTime.now - rand(40), sid: "USER_#{n}")
end

puts "Finished creating users at #{Time.now}"

#Have 60% of users create between 1 and 3 rooms

CreatedUser.all.each do |user|
  if rand < 0.6
    (rand(3) + 1).times do
      room = CreatedRoom.create(
        created_at: user.created_at + rand(DateTime.now - user.created_at).to_i,
                         sid: user.sid,
                         room_id: CreatedRoom.count + 1
                         )
      CreatedPermission.create(
        room_id: room.room_id, sid: room.sid, created_at: room.created_at
        )
    end
  end
end

puts "Finished creating rooms at #{Time.now}"

#Give each user permissions to between 1 and 3 rooms

CreatedUser.all.each do |user|
  (rand(3) + 1).times do
    room = CreatedRoom.all.sample
    unless CreatedPermission.where(sid: user.sid, room_id: room.room_id).first
      CreatedPermission.create(sid: user.sid,
            created_at: room.created_at +
            rand(DateTime.now - room.created_at).to_i,
            room_id: room.room_id)
    end
  end
end

puts "Finished creating permissions at #{Time.now}"

#Have each user create between 0 and 20 messages

CreatedUser.all.each do |user|
  rand(21).times do
    permission = CreatedPermission.where(sid: user.sid).sample
    CreatedMessage.create(sid: user.sid,
          created_at: permission.created_at +
          rand(DateTime.now - permission.created_at).to_i,
          room_id: permission.room_id)
  end
end

puts "Finished creating messages at #{Time.now}"

#Set the redis counts
Aggregate.counter.set('total_users', CreatedUser.count)
Aggregate.counter.set('total_messages', CreatedMessage.count)
Aggregate.counter.set('total_rooms', CreatedRoom.count)
Aggregate.counter.set('total_permissions', CreatedPermission.count)

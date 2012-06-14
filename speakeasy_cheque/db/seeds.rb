# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

CreatedUser.destroy_all
CreatedRoom.destroy_all
CreatedMessage.destroy_all

100.times do |n|
  CreatedUser.create(created_at: DateTime.now, sid: "TODAY_#{n}")
  CreatedRoom.create(created_at: DateTime.now, sid: "TODAY_#{n}")
  CreatedMessage.create(created_at: DateTime.now, sid: "TODAY_#{n}")
end

100.times do |n|
  CreatedUser.create(created_at: DateTime.now - 1, sid: "YESTERDAY_#{n}")
  CreatedRoom.create(created_at: DateTime.now - 1, sid: "YESTERDAY_#{n}")
  CreatedMessage.create(created_at: DateTime.now - 1, sid: "YESTERDAY_#{n}")
end


100.times do |n|
  CreatedUser.create(created_at: DateTime.now - 2, sid: "LONGAGO_#{n}")
  CreatedRoom.create(created_at: DateTime.now - 2, sid: "LONGAGO_#{n}")
  CreatedMessage.create(created_at: DateTime.now - 2, sid: "LONGAGO_#{n}")
end

$redis.set('total_users', 300)
$redis.set('total_messages', 300)
$redis.set('total_rooms', 300)

json.array! @messages do |json, message|
  json.body message.body
  json.id message.id
  json.username message.username
  json.room_id message.room_id
end

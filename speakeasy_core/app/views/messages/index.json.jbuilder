json.array! @messages do |json, message|
  json.body message.body
  json.id message.id
  json.room_id message.room_id
  json.username message.username
end

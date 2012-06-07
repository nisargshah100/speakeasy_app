json.array! @messages do |json, message|
  json.id message.id
  json.room_id message.room_id
  json.body message.body
end

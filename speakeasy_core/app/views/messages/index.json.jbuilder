json.array! @messages do |json, message|
  json.room_id message.room_id
  json.body message.body
end

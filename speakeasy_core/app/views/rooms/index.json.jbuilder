json.rooms @rooms do |json, room|
  json.id room.id
  json.name room.name
  json.description room.description
  json.user_id room.user_id
end

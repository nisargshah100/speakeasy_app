json.array! @rooms do |json, room|
  json.id room.id
  json.name room.name
  json.description room.description
end

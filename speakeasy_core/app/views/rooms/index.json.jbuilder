json.array! @rooms do |json, room|
  json.name room.name
  json.description room.description
end

json.array! @rooms do |json, room|
  json.id room.id
  json.name room.name
  json.description room.description
  json.github_url room.github_url
end

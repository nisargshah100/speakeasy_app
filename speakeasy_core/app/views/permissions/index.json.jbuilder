json.array! @permissions do |json, permission|
  json.id permission.id
  json.email permission.email
end
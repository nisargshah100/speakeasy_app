json.array! @messages do |json, message|
  json.body message.body
end

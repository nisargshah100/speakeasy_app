json.id @room.id
json.name @room.name
json.description @room.description
json.owner @room.sid == @user.sid
json.github_url @room.github_url

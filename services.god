path = File.expand_path(File.dirname(__FILE__))

AUTH_SERVER_PORT = 5000
AUTH_DRB_PORT = 6000

MESSAGING_DRB_PORT = 6001
PUSHER_APP_ID = 21540
PUSHER_KEY = 'abeba495377a1af3615e'
PUSHER_SECRET = '48fb1f43cd8c6d8dd03b'

FRONTEND_SERVER_PORT = 5002

CORE_SERVER_PORT = 5003

GITHUB_PORT = 5004

SEARCH_PORT = 5005

# System files

# God.watch do |w|
#   w.name = "redis"
#   w.start = "redis-server"
#   w.keepalive
# end

# Our Processes

God.watch do |w|
  w.name = "authentication server"
  w.start = "cd #{path}/speakeasy_bouncer/; bundle exec thin start -p #{AUTH_SERVER_PORT}"
  w.keepalive
end

God.watch do |w|
  w.name = "authentication drb"
  w.start = "cd #{path}/speakeasy_bouncer/; DRB_PORT=#{AUTH_DRB_PORT} rake drb"
  w.keepalive
end

God.watch do |w|
  w.name = "messaging service"
  w.start = "cd #{path}/speakeasy_dumbwaiter/; PUSHER_APP_ID=#{PUSHER_APP_ID} PUSHER_KEY=#{PUSHER_KEY} PUSHER_SECRET=#{PUSHER_SECRET} DRB_PORT=#{MESSAGING_DRB_PORT} ruby server.rb"
  w.keepalive
end

God.watch do |w|
  w.name = "frontend server"
  w.start = "cd #{path}/speakeasy_vaudeville/; bundle exec thin start -p #{FRONTEND_SERVER_PORT}"
  w.keepalive
end

God.watch do |w|
  w.name = "core server"
  w.start = "cd #{path}/speakeasy_core/; bundle exec thin start -p #{CORE_SERVER_PORT}"
  w.keepalive
end

God.watch do |w|
  w.name = "github server"
  w.start = "cd #{path}/speakeasy_github/; bundle exec thin start -p #{GITHUB_PORT}"
  w.keepalive
end

God.watch do |w|
  w.name = "search server"
  w.start = "cd #{path}/speakeasy_gumshoe/; bundle exec thin start -p #{SEARCH_PORT}"
  w.keepalive
end

God.watch do |w|
  w.name = "search redis server"
  w.start = "cd #{path}/speakeasy_gumshoe/; rake subscribe"
  w.keepalive
end

God.watch do |w|
  w.name = "search indexer"
  w.start = "cd #{path}/speakeasy_gumshoe/; rake index"
  w.keepalive
end

God.watch do |w|
  w.name = "logger redis server"
  w.start = "cd #{path}/speakeasy_cheque/; rake subscribe"
  w.keepalive
end

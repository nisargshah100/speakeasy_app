path = File.expand_path(File.dirname(__FILE__))

BASE_URL = 'http://localhost:9000/'

AUTH_SERVER_PORT = 5000
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
  w.start = "cd #{path}/speakeasy_bouncer/; BASE_URL=#{BASE_URL} bundle exec thin start -p #{AUTH_SERVER_PORT}"
  w.keepalive
end

God.watch do |w|
 w.name = "faye"
 w.start = "cd #{path}/speakeasy_dumbwaiter/; ruby faye.rb"
 w.keepalive
end

God.watch do |w|
  w.name = "frontend server"
  w.start = "cd #{path}/speakeasy_vaudeville/; BASE_URL=#{BASE_URL} bundle exec thin start -p #{FRONTEND_SERVER_PORT}"
  w.keepalive
end

God.watch do |w|
  w.name = "core server"
  w.start = "cd #{path}/speakeasy_core/; BASE_URL=#{BASE_URL} bundle exec thin start -p #{CORE_SERVER_PORT}"
  w.keepalive
end

God.watch do |w|
  w.name = "github server"
  w.start = "cd #{path}/speakeasy_github/; BASE_URL=#{BASE_URL} bundle exec thin start -p #{GITHUB_PORT}"
  w.keepalive
end

God.watch do |w|
  w.name = "search server"
  w.start = "cd #{path}/speakeasy_gumshoe/; BASE_URL=#{BASE_URL} bundle exec thin start -p #{SEARCH_PORT}"
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

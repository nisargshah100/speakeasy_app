require 'drb'

task :drb => :environment do
  port = ENV['DRB_PORT']

  DRb.start_service "druby://:#{port}", AuthService
  puts "Server running at #{DRb.uri}"

  DRb.thread.join
end
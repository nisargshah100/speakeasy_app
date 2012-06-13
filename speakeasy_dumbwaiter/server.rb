require 'sinatra'
require 'faye'
require 'json'

faye = Faye::Client.new("#{ENV['BASE_URL']}/faye")

get '/' do
  channel = params[:channel]
  event = params[:event]
  data = params[:data]

  if channel and data
    channel = "#{channel}/#{event}" if event
    faye.publish(channel, data)
    return true.to_json
  end

  false.to_json
end
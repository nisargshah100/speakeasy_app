class Api::ConnectionsController < ApplicationController
  before_filter :require_login

  def create
    connected_channel = params['connected']
    disconnected_channel = params['disconnected']

    disconnect(disconnected_channel)
    connect(connected_channel)

    render :json => true
  end

  def index
    channel = params['channel'] || ""
    users = get_users("/channel/#{channel}")
    render :json => users.map { |sid,user| user }
  end

  private

  def connect(channel)
    MessengerService.ping(channel, {
      'channel' => channel,
      'user' => current_user.as_json(:only => ['name', 'sid'])
    }, event='connected')

    set_user("/channel/#{channel}")
  end

  def disconnect(channel)
    MessengerService.ping(channel, {
      'channel' => channel,
      'user' => current_user.as_json(:only => ['name', 'sid'])
    }, event='disconnected')

    remove_user("/channel/#{channel}")
  end

  def set_user(channel)
    users = get_users(channel)
    users[current_user['sid']] = current_user['name']
    $redis.set(channel, users.to_json)
  end

  def remove_user(channel)
    users = get_users(channel)
    users.delete(current_user['sid'])
    $redis.set(channel, users.to_json)
  end

  def get_users(channel)
    JSON.load($redis.get(channel) || "{}")
  end

end

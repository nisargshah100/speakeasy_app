class Api::ConnectionsController < ApplicationController
  before_filter :require_login

  def create
    connected_channel = params['connected']
    disconnected_channel = params['disconnected']

    disconnect(disconnected_channel)
    connect(connected_channel)

    render :json => true
  end

  private

  def connect(channel)
    MessengerService.ping(channel, {
      'channel' => channel,
      'user' => current_user.as_json(:only => ['name', 'sid'])
    }, event='connected')
  end

  def disconnect(channel)
    MessengerService.ping(channel, {
      'channel' => channel,
      'user' => current_user.as_json(:only => ['name', 'sid'])
    }, event='disconnected')
  end

end

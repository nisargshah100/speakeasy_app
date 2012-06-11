require 'drb'

AuthService = DRbObject.new nil, 'druby://:6000'
Messenger = DRbObject.new nil, 'druby://:6001'

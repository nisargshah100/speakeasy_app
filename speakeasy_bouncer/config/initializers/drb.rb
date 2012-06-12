require 'drb'

MessengerService = DRbObject.new nil, 'druby://:6001'
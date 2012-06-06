require 'drb'

AuthService = DRbObject.new nil, 'druby://:6000'

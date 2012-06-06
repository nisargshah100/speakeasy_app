require 'drb'

MESSENGER ||= DRbObject.new nil, 'druby://:6001'
class TimePeriod
  def self.day
    interval = 1.hour * 1000
    start = 1.day.ago.at_midnight.to_i * 1000
    return interval, start
  end

  def self.week
    interval = 1.day * 1000
    start = 1.week.ago.at_midnight.to_i * 1000
    return interval, start
  end

  def self.month
    interval = 1.day * 1000
    start = 1.month.ago.at_midnight.to_i * 1000
    return interval, start
  end

  def self.all
    interval = 1.day * 1000
    start = DAY_ZERO.to_i * 1000
    return interval, start
  end
end
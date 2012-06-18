class Chart
  def self.title_for(primary, secondary)
    if primary && secondary
      "#{primary.titleize} per #{secondary.titleize.singularize}"
    elsif primary
      primary.titleize
    else
      "Select a Metric"
    end
  end

  def self.series_for(primary, secondary, time_period)
    if primary == secondary
      set_series_to_ones_for(primary, time_period)
    else
      primary_series = primary_series_for(primary, time_period)
      secondary_series = secondary_series_for(
        secondary, primary_series, time_period)
      primary_series.each_with_index.map {
        |point, index| (point.to_f/secondary_series[index].to_f).round(2) }
    end
  end

  private

  def self.primary_series_for(metric, time_period)
    if metric
      series = metric.classify.constantize.series(time_period)
    else
      []
    end
  end

  def self.secondary_series_for(metric, primary_series, time_period)
    if metric
      series = metric.classify.constantize.series(time_period)
      set_min_to_one_for(series)
    else
      (1..primary_series.length).map { |n| 1 }
    end
  end

  def self.set_min_to_one_for(series)
    series.map { |point| point == 0 ? 1 : point }
  end

  def self.set_series_to_ones_for(metric, time_period)
    primary_series_for(metric, time_period).map { |point| 1 }
  end

  module TimePeriod
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
end

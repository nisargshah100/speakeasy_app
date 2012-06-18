module ChartSeriesMethods
  def series(time_period)
    case time_period
    when "day"
      (0..23).map { |hour| total_at(hour) }
    when "week"
      (1.week.ago.to_date..Date.today).map { |date| total_on(date) }
    when "month"
      (1.month.ago.to_date..Date.today).map { |date| total_on(date) }
    when "all"
      (DAY_ZERO.to_date..Date.today).map { |date| total_on(date) }
    end
  end

  def total_on(date)
    where(:created_at.gt => date - 1, :created_at.lte => date).count
  end

  def total_at(number_of_hours)
    where(:created_at.gt => 1.day.ago.at_midnight + number_of_hours.hours,
          :created_at.lte => 1.day.ago.at_midnight +
          (number_of_hours + 1).hours).count
  end
end

module ChartSeriesMethods
  def series
    (1.week.ago.to_date..Date.today).map { |date| total_on(date) }
  end

  def total_on(date)
    where(:created_at.gt => date - 1, :created_at.lte => date).count
  end
end

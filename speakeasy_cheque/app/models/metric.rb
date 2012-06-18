class Metric
  KPI_TIME_PERIOD = 2

  def self.days
    (DateTime.now - DAY_ZERO).to_f
  end

  def self.users
    return Users.per_day, Users.trending_up?
  end

  def self.messages
    return Messages.per_user, Messages.trending_up?
  end

  module Users
    def self.per_day
      recent_count/KPI_TIME_PERIOD
    end

    def self.trending_up?
      per_day >= historical_per_day
    end

    def self.historical_count
      CreatedUser.where(
        :created_at.lte => DateTime.now - KPI_TIME_PERIOD).count
    end

    private

    def self.recent_count
      CreatedUser.where(
        :created_at.gt => DateTime.now - KPI_TIME_PERIOD).count
    end

    def self.historical_per_day
      CreatedUser.count / Metric.days
    end
  end

  module Messages
    def self.per_user
      (CreatedMessage.count.to_f / CreatedUser.count.to_f).round(2)
    end

    def self.trending_up?
      per_user >= historical_per_user
    end

    private

    def self.historical_per_user
      (historical_count.to_f / Users.historical_count.to_f)
    end

    def self.historical_count
      CreatedMessage.where(
        :created_at.lte => DateTime.now - KPI_TIME_PERIOD).count
    end
  end
end

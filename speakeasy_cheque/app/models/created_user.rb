class CreatedUser
  include Mongoid::Document
  field :sid, type: String
  field :name, type: String
  field :email, type: String
  field :created_at, type: DateTime

  after_create :increment_users

  def self.create_from_on_tap(data)
    CreatedUser.create( :sid => data["sid"],
                        :name => data["name"],
                        :email => data["email"],
                        :created_at => DateTime.parse(data["created_at"]) )
  end

  def increment_users
    Aggregate.increment_users
  end
end

class UserDecorator < Draper::Base
  decorates :user

  def as_json(*params)
    model.as_json(:only => [:email, :name, :token, :sid])
  end
end

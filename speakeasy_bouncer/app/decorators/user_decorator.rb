class UserDecorator < Draper::Base
  decorates :user

  def as_json(*params)
    return {} unless model
    
    data = [:email, :name, :sid]
    if h.current_user and h.current_user == model
      data.append(:token)
    end

    model.as_json(:only => data)
  end
end

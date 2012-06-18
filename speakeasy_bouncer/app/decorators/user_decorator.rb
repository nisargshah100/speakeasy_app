class UserDecorator < Draper::Base
  decorates :user

  def as_json(*params)
    return {} unless model

    data = [:email, :name, :sid, :is_admin]
    if h.current_user and h.current_user == model
      data.append(:token)
    end

    data = model.as_json(:only => data)
    data['gravatar'] = Gravatar.new(model.email).image_url
    data
  end
end

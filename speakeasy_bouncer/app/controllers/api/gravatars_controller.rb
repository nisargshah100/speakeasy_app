class Api::GravatarsController < ApplicationController

  def show
    sid = params[:id]
    user = User.where(:sid => sid).first

    if user
      render :text => Gravatar.new(user.email).image_data
    else
      render :text => ""
    end
  end

end

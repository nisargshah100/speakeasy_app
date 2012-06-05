class Api::UsersController < ApplicationController
  before_filter :require_login, :only => :edit

  def create
    user = User.new(params[:user], :as => :admin)
    if user.save
      success(UserDecorator.decorate(user), 201)
    else
      validation_error(user)
    end
  end

  def edit
    if not AuthService.authenticate(current_user.email, params[:user][:password])
      error(['You must enter your current password to edit account'])
    elsif current_user.update_attributes(params[:user], :as => :admin)
      success(UserDecorator.decorate(current_user), 200)
    else
      validation_error(current_user)
    end
  end

end

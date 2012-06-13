class Api::UsersController < ApplicationController
  before_filter :require_login, :only => :edit

  def show
    token = params[:id]
    user = User.where(:token => token).first
    success(UserDecorator.decorate(user), 200)
  end

  def show_by_sids
    sids = JSON.parse(params[:sids])
    users = []

    for sid in sids
      users.append(UserDecorator.decorate(User.where(:sid => sid).first))
    end

    render :json => users
  end

  def show_by_email
    email = params[:email]
    user = User.where(:email => email).first
    success(UserDecorator.decorate(user), 200)
  end

  def create
    user = User.new(params[:user], :as => :admin)
    if user.save
      success(UserDecorator.decorate(user), 201)
    else
      validation_error(user)
    end
  end

  def edit
    if current_user.update_attributes(params[:user], :as => :admin)
      success(UserDecorator.decorate(current_user), 200)
    else
      validation_error(current_user)
    end
  end

end

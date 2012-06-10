class AppController < ApplicationController
  # before_filter :require_login
  before_filter :current_user

  def index
  end

end

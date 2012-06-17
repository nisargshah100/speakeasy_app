class AppController < ApplicationController
  before_filter :require_login!

  def index
    current_user
  end

end

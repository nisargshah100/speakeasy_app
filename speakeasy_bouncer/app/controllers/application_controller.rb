class ApplicationController < ActionController::Base
  
  private

  def success(obj, code=201)
    render :json => obj, :status => code
  end

  def error(obj, code=400)
    render :json => obj, :status => code
  end

  def validation_error(obj)
    error(obj.errors)
  end

  def require_login
    unless current_user
      error({}, code=403)
      false
    end
  end

  def current_user
    @current_user ||= AuthService.get_user(params[:token])
  end

end

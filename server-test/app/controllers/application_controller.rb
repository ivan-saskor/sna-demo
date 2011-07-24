class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :fetch_logged_user

  def authenticate
    unless @current_user
      render :json => {'ErrorCode' => 101, 'ErrorMessage' => 'Invalid user data'}, :status => :unauthorized
      return false
    end
  end

  def fetch_logged_user
    Rails.logger.info env.inspect
    unless request.env['HTTP_EMAIL'].blank?
      @current_user = Person.where(:email => request.env['HTTP_EMAIL'], :password => request.env['HTTP_PASSWORD']).first
    end
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def welcome
    render plain: 'Welcome to Dr. Open Source'
  end
end

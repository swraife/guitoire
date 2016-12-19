class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :current_user_or_initialize

  def current_user_or_initialize
    @current_user = current_user || User.new
  end
end

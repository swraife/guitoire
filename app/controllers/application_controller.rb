class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_performer
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :store_current_location, :unless => :devise_controller?
  before_action :create_first_performer

  private

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def store_current_location
    store_location_for(:user, request.url)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end

  def current_ability
    @current_ability ||= Ability.new(current_performer, params)
  end

  def current_performer
    if signed_in?
      @current_performer ||=
        if session[:performer_id]
          current_user.performers.find(session[:performer_id])
        else
          current_user.default_performer
        end
    end
  end

  def create_first_performer
    redirect_to new_performer_path if signed_in? && current_performer == nil
  end

  rescue_from CanCan::AccessDenied do |exception|
    render file: "#{Rails.root}/public/403", formats: [:html], status: 403, layout: false
  end
end

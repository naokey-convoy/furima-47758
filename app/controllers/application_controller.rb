class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :basic_auth, if: :basic_auth_enabled?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: %i[nickname last_name first_name last_name_kana first_name_kana birth_date]
    )
  end

  private

  def basic_auth_enabled?
    !Rails.env.test? && ENV["BASIC_AUTH_USER"].present? && ENV["BASIC_AUTH_PASSWORD"].present?
  end

  def basic_auth
    expected_username = ENV["BASIC_AUTH_USER"]
    expected_password = ENV["BASIC_AUTH_PASSWORD"]

    authenticate_or_request_with_http_basic do |username, password|
      expected_username.present? && expected_password.present? &&
        ActiveSupport::SecurityUtils.secure_compare(username, expected_username) &
          ActiveSupport::SecurityUtils.secure_compare(password, expected_password)
    end
  end
end

class ApplicationController < ActionController::Base
  before_action :basic_auth

  private

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

class ApplicationController < ActionController::Base
  helper_method :current_user

  # Set security headers
  before_action :set_security_headers

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def set_security_headers
    # Content Security Policy (CSP) - Example allowing only same-origin scripts
    response.headers['Content-Security-Policy'] = "script-src 'self'"

    # HTTP Strict Transport Security (HSTS) - Forces browser to use HTTPS
    response.headers['Strict-Transport-Security'] = 'max-age=31536000'

    # X-Content-Type-Options - Prevents MIME type sniffing
    response.headers['X-Content-Type-Options'] = 'nosniff'

    # X-Frame-Options - Protects against Clickjacking
    response.headers['X-Frame-Options'] = 'SAMEORIGIN'

    # X-XSS-Protection - Cross-Site Scripting (XSS) protection
    response.headers['X-XSS-Protection'] = '1; mode=block'
  end
  
  def log_authentication_attempt(username, success)
    Rails.logger.info "Authentication attempt for username: #{username}. Success: #{success ? 'Yes' : 'No'}."
  end
end

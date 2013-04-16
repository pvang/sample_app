class ApplicationController < ActionController::Base
  protect_from_forgery

  include SessionsHelper # including the Sessions helper module into the Application controller

  # force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end
end
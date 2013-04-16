module SessionsHelper

  def sign_in(user) # sign_in function
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def current_user=(user) # assignment to current_user
    @current_user = user
  end

  def current_user # finding the current user using the remember_token
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user) # correct_user filter uses the current_user? boolean method, (defined here)
    user == current_user
  end

  def redirect_back_or(default) # to implement friendly forwarding
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location # to implement friendly forwarding
    session[:return_to] = request.url
  end

  def signed_in? # signed_in? helper method
    !current_user.nil?
  end

  def sign_out # sign out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

end
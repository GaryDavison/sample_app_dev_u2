module SessionsHelper
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end #sign_in

  def current_user=(user)
    @current_user = user
  end #current_user (params)

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end  #current user (no params)

  def current_user?(user)
    user == current_user
  end #current user?

  def signed_in?
    !current_user.nil?
  end #signed in

  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.encrypt(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end  #sign_out


end

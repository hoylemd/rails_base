module SessionsHelper
  def log_in(user, permanent = false)
    # TODO: test the permanent flag
    permanent ? remember(user) : forget(user)
    session[:user_id] = user.id
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user
    # TODO: update test
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  # Remembers a user in a persistent session.
  def remember(user)
    # TODO: test
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Forgets a persistent session.
  def forget(user)
    # TODO: test
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
end

module AclHelper
  include SessionsHelper

  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = 'Please log in first'
    render 'sessions/new', status: :unauthorized
  end

  def correct_user_or_go_home(user)
    return if logged_in_user
    return if current_user? user
    @micropost  = current_user.microposts.build
    @feed_items = current_user.feed.paginate(page: params[:page])
  end

  def current_user?(user)
    current_user == user
  end
end

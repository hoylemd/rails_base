module AclHelper
  include SessionsHelper

  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = 'Please log in first'
    render 'sessions/new', status: :unauthorized
    true # return true to indicate that this triggered things
  end

  # untested
  def correct_user_or_go_home(user)
    permission_denied unless current_user? user
  end

  def current_user?(user)
    current_user == user
  end

  private

  def permission_denied(template = 'static_pages/home')
    flash[:danger] = 'Sorry, you don\'t have permission to do that'

    if template == 'static_pages/home'
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
    render template, status: :unauthorized
  end
end

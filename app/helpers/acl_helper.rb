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
  def correct_user_or_render_401(user, options = {})
    permission_denied options unless correct_user? user, options
  end

  # Actual helper functions
  def current_user?(user)
    current_user == user
  end

  def correct_user?(user, options = {})
    options = {
      test: (proc do |expected_user|
        current_user && (current_user?(expected_user) || current_user.admin?)
      end)
    }.merge options

    options[:test].call user
  end

  private

  def render_unauthorized(template)
    if template == 'static_pages/home' && current_user
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
    render template, status: :unauthorized
  end

  def permission_denied(options)
    options = {
      template: 'static_pages/home',
      flash: 'Sorry, you don\'t have permission to do that'
    }.merge options

    flash[:danger] = options[:flash]

    render_unauthorized options[:template]
  end
end

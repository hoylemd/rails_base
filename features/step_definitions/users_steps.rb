def user_identity
  {
    name: 'Leia Organa',
    email: 'leia@rebelalliance.org',
    password: 'password'
  }
end

def admin_identity
  {
    name: 'Darth Vader',
    email: 'darth_vader@galacticempire.gov',
    password: 'password'
  }
end

def unverified_identity
  {
    name: 'Barack Obama',
    email: 'potus@not.us.gov',
    password: 'password'
  }
end

def identity
  @identity ||= user_identity
end

def enter_email(email = identity[:email])
  @current_email = email
  fill_in 'Email', with: @current_email
end

def enter_password(password = identity[:password])
  @current_password = password
  fill_in 'Password', with: @current_password
end

When(/I enter my email$/) do
  enter_email
end

When(/I enter my password$/) do
  enter_password
end

def log_in(credentials = identity)
  visit_page('login')

  enter_email credentials[:email]
  enter_password credentials[:password]

  click_button 'Log in'
end

Given(/I am logged into the app$/) do
  log_in identity
end

Given(/I am a( regular user|n admin|n unverified user)$/) do |who|
  case who
  when ' regular user'
    @identity = user_identity
  when 'n admin'
    @identity = admin_identity
  when 'n unverified user'
    @identity = unverified_identity
  end
end

# valid options:
#  size: the size of the gravatar. default: 80
#  selector: custom selector to use. default: '.gravatar'
#  email: email address for the expected gravatar. defaults to current user
# extra options
def should_see_gravatar(options = {})
  size = options.delete(:size) || 80
  options[:selector] ||= '.gravatar'
  email = options.delete(:email) || identity[:email]

  gravatar_id = Digest::MD5.hexdigest(email.downcase)
  url = "https://secure.gravatar.com/avatar/#{gravatar_id}?size=#{size}"
  assert_see_img_with_src url, options
end

Then(/I should see my gravatar$/) do
  should_see_gravatar
end

Then(/I should see my user info$/) do
  should_see_gravatar selector: '.user_info .gravatar', count: 1
  assert_selector 'h1', text: identity[:name]
  # assert_see_links 'user profile',
end

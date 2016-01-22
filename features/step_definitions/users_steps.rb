def user_identity
  {
    name: 'Leia Organa',
    email: 'leia@rebelalliance.org',
    password: 'password',
    id: 1
  }
end

def admin_identity
  {
    name: 'Darth Vader',
    email: 'darth_vader@galacticempire.gov',
    password: 'password',
    id: 2
  }
end

def unverified_identity
  {
    name: 'Barack Obama',
    email: 'potus@not.us.gov',
    password: 'password',
    id: 3
  }
end

def identity
  @identity ||= user_identity
end

def random_name
  random_string numbers: false, special: false
end

def random_email
  random_string(upper_case: false, numbers: false, special: false) +
    '@example.com'
end

Given(/I am a( regular user|n admin|n unverified user| new user)$/) do |who|
  case who
  when ' regular user'
    @identity = user_identity
  when 'n admin'
    @identity = admin_identity
  when 'n unverified user'
    @identity = unverified_identity
  when ' new user'
    @identity = {
      name: random_name,
      email: random_email,
      password: 'password'
    }
  end
end

def enter_email(email = identity[:email])
  fill_in 'Email', with: email
end

def enter_password(password = identity[:password])
  fill_in 'Password', with: password
end

def enter_name(name = identity[:name])
  fill_in 'Name', with: name
end

When(/I enter my email$/) do
  enter_email
end

When(/I enter my password$/) do
  enter_password
end

When(/I enter my name$/) do
  enter_name
end

def log_in(credentials = identity)
  visit_page('login')

  enter_email credentials[:email]
  enter_password credentials[:password]

  click_button 'Log in'
end

Given(/I am logged into the app$/) do
  log_in
end

When(/I log in$/) do
  log_in
end

When(/I log out$/) do
  visit_page('logout')
end

# valid options:
#  size: the size of the gravatar. default: 50
#  selector: custom selector to use. default: '.gravatar'
#  email: email address for the expected gravatar. defaults to current user
# extra options
def should_see_gravatar(options = {})
  size = options.delete(:size) || 50
  options[:selector] ||= '.gravatar'
  email = options.delete(:email) || identity[:email]

  gravatar_id = Digest::MD5.hexdigest(email.downcase)
  url = "https://secure.gravatar.com/avatar/#{gravatar_id}?size=#{size}"
  assert_see_img_with_src url, options
end

Then(/I should see my gravatar$/) do
  should_see_gravatar
end

When(/I visit my profile page$/) do
  visit "/users/#{identity[:id]}"
end

Then(/I should see my user profile$/) do
  should_see_gravatar selector: '.user_info .gravatar', size: 80
  assert_selector 'h1', text: identity[:name]
end

Then(/I should see a permission denied flash message$/) do
  assert_flash type: 'danger',
               text: "Sorry, you don't have permission to do that"
end

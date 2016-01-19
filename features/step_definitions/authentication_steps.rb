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
    password: 'hunter2'
  }
end

def log_in(credentials)
  @current_email = credentials[:email]
  @current_password = credentials[:password]

  visit_page('login')

  fill_in 'Email', with: @current_email
  fill_in 'Password', with: @current_password

  click_button 'Log in'
end

Given(/I am logged into the app$/) do
  @identity ||= user_identity
  log_in @identity
end

Given(/I am a( regular user|n admin|n unverified user)$/) do |identity|
  case identity
  when ' regular user'
    @identity = user_identity
  when 'n admin'
    @identity = admin_identity
  when 'n unverified user'
    @identity = unverified_identity
  end
end

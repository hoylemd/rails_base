def user_credentials
  { email: 'leia@rebelalliance.org', password: 'password' }
end

def admin_credentials
  { email: 'darth_vader@galacticempire.gov', password: 'password' }
end

def unverified_credentials
  { email: 'potus@not.us.gov', password: 'hunter2' }
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
  log_in user_credentials
end

Given(/I am logged in as a( regular user|n admin|n unverified user)$/
     ) do |as_whom|
end

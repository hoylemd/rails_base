def enter_random_email
  @identity[:email] = fill_in_random('Email', prefix: 'email',
                                              suffix: '@example.com',
                                              upper_case: false)
end

When(/I enter a random email$/) do
  enter_random_email
end

def enter_random_password(short = false)
  pw = fill_in_random('Password', short ? { length: 4 } : { prefix: 'pw' })
  @identity[:password] = pw
end

When(/I enter a random (short )?password$/) do |short|
  enter_random_password short
end

def enter_random_name
  @identity[:name] = fill_in_random 'Name', numbers: false, special: false
end

When(/I enter a random name$/) do
  enter_random_name
end

def confirm_password(incorrect = false)
  pw = incorrect ? 'wroooong!!!' : @identity[:password]
  fill_in 'Confirmation', with: pw
end

When(/I confirm my password( incorrectly)?$/) do |incorrect|
  confirm_password incorrect
end

def complete_signup_form
  assert_element_present('form.new_user')
  enter_random_name
  enter_random_email
  enter_random_password
  confirm_password
  click_on 'Create my Account'
end

When(/I complete the signup form$/) do
  complete_signup_form
end

Then(/I should see my email$/) do
  assert_text @identity[:email]
end

def sign_up
  visit_page 'signup'
  complete_signup_form
end

When(/I sign up$/) do
  sign_up
end

When(/I remember my user id$/) do
  assert_at_page 'user profile'
  @identity[:id] = current_url.split('/').last.to_i
end

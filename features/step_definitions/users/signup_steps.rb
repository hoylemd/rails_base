def confirm_password(incorrect = false)
  pw = incorrect ? 'wroooong!!!' : @identity[:password]
  fill_in 'Confirmation', with: pw
end

When(/I confirm my password( incorrectly)?$/) do |incorrect|
  confirm_password incorrect
end

def complete_signup_form
  # TODO: this should fill out the form with data in @identity, not generate it
  enter_name
  enter_email
  enter_password
  confirm_password
  click_on 'Create my Account'
end

When(/I complete the signup form$/) do
  complete_signup_form
end

def note_new_user_info
  @identity[:id] = find('.user_id').text.to_i
  @identity[:verification_token] = find('.v_token').text
end

When(/I note my user information$/) do
  note_new_user_info
end

def sign_up
  visit_page 'signup'
  # TODO: this should instantiate a new identity hash first
  complete_signup_form
  note_new_user_info
end

When(/I sign up$/) do
  sign_up
end

def verify_email
  url = "/email_verifications/#{identity[:verification_token]}/edit" \
        "?email=#{identity[:email]}"
  visit url
end

When(/I verify my email$/) do
  verify_email
end

Then(/I should see my email$/) do
  assert_text @identity[:email]
end

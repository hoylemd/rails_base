Given(/I have an account/) do
  sign_up
  click_on 'Log Out'
end

Given(/I am logged in$/) do
  sign_up
  connect_account
end

Then(/I should see my user profile/) do
  assert_not @username.empty?
  expect(page).to have_content("Username: #{@username}")
end

Then(/I should be logged in/) do
  assert_see_links('users', 1)
  assert page.html.include? 'Log out'
end

Then(/I should not be logged in/) do
  # TODO: implement this
end

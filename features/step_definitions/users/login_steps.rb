Given(/I am logged in$/) do
  log_in
end

Then(/I should be logged in$/) do
  # TODO: this should actually check cookies
  assert_see_links('users', 1)
  assert page.html.include? 'Log out'
end

Then(/I should not be logged in$/) do
  # TODO: implement this (checking cookies)
  assert_see_links('users', 0)
  assert_see_links('signup', 2)
  assert_see_links('login', 1)
end

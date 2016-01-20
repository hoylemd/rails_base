Given(/I am logged in$/) do
  log_in
end

def logged_in?(negate = false)
  # TODO: this should actually check cookies
  if negate
    assert_see_links('users', 0)
    assert_see_links('signup', 2)
    assert_see_links('login', 1)
  else
    assert_see_links('users', 1)
    assert page.html.include? 'Log out'
  end
end

Then(/I should( not)? be logged in$/) do |negate|
  logged_in? negate
end

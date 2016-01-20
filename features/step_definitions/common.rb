# rubocop:disable Style/MethodLength
def page_mappings
  @page_mappings ||= {
    'signup' => '/signup',
    'home' => '/',
    'login' => '/login',
    'logout' => '/logout',
    'help' => '/help',
    'about' => '/about',
    'contact' => '/contact',
    'users' => '/users',
    'user profile' => %r{/users/[0-9]+$}
  }
end
# rubocop:enable Style/MethodLength

def page_known?(page_name)
  page_mappings.key?(page_name)
end

def assert_page_known(page_name)
  assert page_known?(page_name),
         "the specified page '#{page_name}' is not known to the test suite"
end

def assert_at_page(page_name)
  assert_page_known page_name
  path = page_mappings[page_name]
  assert path.match(current_path), "Expected to be at #{path}, " \
                                   "but was actually at #{current_path}"
end

def visit_page(page_name)
  assert_page_known page_name
  visit page_mappings[page_name]
end

Given(/I am on the (.*) page$/) do |page_name|
  visit_page(page_name)
end

When(/I visit the (.*) page$/) do |page_name|
  visit_page(page_name)
end

When(/I hover over "(.*)"$/) do |text|
  find('.js-hoverable', text: text).hover
end

When(/I click "(.*)"$/) do |text|
  click_on text
end

When(/I click the "(.*)" button$/) do |label|
  click_button label
end

Then(/I should see "(.*)"$/) do |text|
  page.assert_text text
end

def field_name_to_css(name)
  ".form-field.form-field-#{string_to_slug name}"
end

Then(/I should see a "(.+)" field$/) do |field_name|
  field = page.find("#{field_name_to_css field_name}")
  assert_find(field, 'label', text: field_name)
  assert_find(field, 'input.form-control')
end

Then(/I should see a success flash$/) do
  assert_selector '.alert.alert-success',
                  'Did not see an expected success flash'
end

Then(/I should not see an error flash$/) do
  assert_no_selector '.alert.alert-danger', 'Saw an unexpected error flash'
end

Then(/I should see an error flash that says "(.*)"$/) do |message|
  locator = '.alert.alert-danger, .error-message'
  assert_element_present(locator, text: message)
end

Then(/I should be on the (.*) pagei$/) do |page|
  assert_element_present(".id-#{page}")
end

When(/I enter "(.+)" into "(.+)"$/) do |text, label|
  fill_in label, with: text
end

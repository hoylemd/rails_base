Given(/I am viewing the app$/) do
  visit '/'
end

def page_mappings
  @page_mappings ||= {
    'signup' => '/signup',
    'home' => '/',
    'login' => '/login'
  }
end

def page_known?(page_name)
  page_mappings.key?(page_name)
end

def assert_page_known(page_name)
  assert page_known?(page_name),
         "the specified page '#{page_name}' is not known to the test suite"
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

When(/I click "(.*)"$/) do |text|
  click_on text
end

Then(/I should see "(.*)"$/) do |text|
  page.assert_text text
end

def assert_see_links(page_name, count)
  if page_known? page_name
    href = page_mappings[page_name]
    message = "Should see exactly #{count} links to the #{page_name} page"
  else
    href = page_name
    message = "Should see exactly #{count} links to #{href}"
  end

  assert page.has_link?('', href: href, count: count), message
end

def link_type_to_locator(type)
  type.chomp! 's'
  {
    'link' => '',
    'CTA' => '.btn.btn-primary'
  }[type]
end

Then(/I should see a link to the (.*) page$/) do |page_name|
  assert_see_links page_name, 1
end

Then(/I should see ([0-9]+) links to the (.*) page$/) do |count, page_name|
  assert_see_links page_name, count.to_s
end

Then(/The page title should be "(.*)"$/) do |page_title|
  assert_equal page.title, page_title
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
  assert page.has_selector? '.alert.alert-success'
end

Then(/I should not see any error messages$/) do
  assert page.has_no_selector? '.alert.alert-danger'
end

Then(/I should see an error message that says "(.*)"$/) do |message|
  locator = '.alert.alert-danger, .error-message'
  assert_element_present(locator, text: message)
end

Then(/I should be on the (.*) pagei$/) do |page|
  assert_element_present(".id-#{page}")
end

When(/I enter "(.+)" into "(.+)"$/) do |text, label|
  fill_in label, with: text
end

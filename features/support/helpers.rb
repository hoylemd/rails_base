# condition assertions
def assert_not_equal(test, unexpected, message = nil)
  message = "[#{test}] was equal to [#{unexpected}]" if message.nil?
  assert test != unexpected, message
end

def assert_not_empty(test, message = nil)
  message = 'passed object was empty' if message.nil?
  refute test.nil?
  begin
    refute test.empty?, message
  rescue NoMethodError
    # if the test object isn't nil, and has no empty? method, it's probably not
    true
  end
  true
end

def assert_gt(left, right, message = nil)
  if message.nil?
    message = "greater-than assertion failed. [#{left}] !> [#{right}]"
  end
  assert left > right, message
end

def assert_lt(left, right, message = nil)
  if message.nil?
    message = "less-than assertion failed. [#{left}] !> [#{right}]"
  end
  assert_gt right, left, message
end

def assert_gte(left, right, message = nil)
  if message.nil?
    message = "greater-than-or-equal assertion failed. [#{left}] !> [#{right}]"
  end
  assert left >= right, message
end

def assert_lte(left, right, message = nil)
  if message.nil?
    message = "less-than-or-equal assertion failed. [#{left}] !> [#{right}]"
  end
  assert_gte right, left, message
end

# Capybara-driven DOM assertions
def assert_find(parent, selector, options = {})
  # options are passed directly to Capybara::Session#find
  # generally, it'll just be {text: 'text you are looking for'}
  found = nil
  begin
    found = parent.find(selector, options)
  rescue Capybara::Ambiguous
    unless message
      message = "found multiple elements '#{selector}'" \
        " with content '#{message}'"
    end
  rescue Capybara::ElementNotFound
    unless message
      message = "failed to find element '#{selector}'"
      message += " with content '#{options[:text]}'" if options[:text]
    end
  end
  fail Minitest::Assertion, message if found.nil?
  found
end

def assert_element_present(selector, options = {})
  assert_find(page, selector, options)
end

def assert_element_has_content(selector, options = {})
  element = assert_element_present(selector, options)
  content = ''
  if element.tag_name == 'img'
    content = element[:src]
  else
    content = element.text
  end
  assert_not_empty(content, "element #{selector} was found, but is empty.")
end

def random_string(options = {})
  # Generates a random string of `length` length
  # options:
  #  length: integer, number of characters to generate. default 8
  #  lower_case: boolean. set to false to exclude lower case characters
  #              default: true
  #  upper_case: boolean. set to false to exclude upper case characters
  #              default: true
  #  numbers: boolean. set to false to exclude numeric characters
  #              default: true
  #  special: boolean. set to false to exclude special characters ( _?&)
  #              default: true

  default_classes = {
    length: 8, lower_case: true, upper_case: true, numbers: true, special: false
  }
  use = default_classes.merge(options || {})

  characters = []
  characters += ('a'..'z').map { |i| i } if use[:lower_case]
  characters += ('A'..'Z').map { |i| i } if use[:upper_case]
  characters += ('0'..'9').map { |i| i } if use[:numbers]
  characters += [' ', '_', '?', '&'] if use[:special]

  if characters.empty?
    fail Exception, 'you need to choose at least one character class!'
  end

  (0...use[:length]).map { characters[rand(characters.length)] }.join
end

def fill_in_random(field, prefix = nil, string_options = nil)
  random = random_string string_options
  string = prefix.nil? ? "#{random}" : "#{prefix}:#{random}"
  fill_in field, with: string
  string
end

def string_to_slug(string)
  string.downcase.strip.tr(' ', '-').gsub(/[^\w-]/, '')
end

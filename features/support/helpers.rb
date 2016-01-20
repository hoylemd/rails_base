# Capybara-driven DOM assertions
def _assert_find_fail_ambiguous_message(selector, options)
  message = "found multiple elements '#{selector}'"
  message += " with content '#{options[:text]}'" if options[:text]
  message
end

def _assert_find_fail_not_found(selector, options)
  message = "failed to find element '#{selector}'"
  message += " with content '#{options[:text]}'" if options[:text]
  message
end

def assert_find(parent, selector, options = {})
  # options are passed directly to Capybara::Session#find
  # generally, it'll just be {text: 'text you are looking for'}
  found = nil
  begin
    found = parent.find(selector, options)
  rescue Capybara::Ambiguous
    message = _assert_find_ambiguous_message selector, options
  rescue Capybara::ElementNotFound
    message = _assert_find_ambiguous_message selector, options
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

def _random_string_build_characters(use)
  characters = []
  characters += ('a'..'z').map { |i| i } if use[:lower_case]
  characters += ('A'..'Z').map { |i| i } if use[:upper_case]
  characters += ('0'..'9').map { |i| i } if use[:numbers]
  characters += [' ', '_', '?', '&'] if use[:special]
  characters
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

  characters = _random_string_build_characters use

  if characters.empty?
    fail Exception, 'you need to choose at least one character class!'
  end

  (0...use[:length]).map { characters[rand(characters.length)] }.join
end

# options:
#  prefix: string to prepend to the random string
#  suffix: string to append to the random string
# remaining options will be passed to random_string()
def fill_in_random(field, options = {})
  prefix = options[:prefix] ? options.delete(:prefix) : ''
  suffix = options[:suffix] ? options.delete(:suffix) : ''

  random = random_string options

  string = "#{prefix}#{random}#{suffix}"
  fill_in field, with: string
  string
end

def string_to_slug(string)
  string.downcase.strip.tr(' ', '-').gsub(/[^\w-]/, '')
end

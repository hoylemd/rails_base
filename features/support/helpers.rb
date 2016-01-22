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

def string_to_slug(string)
  string.downcase.strip.tr(' ', '-').gsub(/[^\w-]/, '')
end

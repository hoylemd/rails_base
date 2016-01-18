Then(/I test my assert_element_present helper/) do
  # TODO: write this test. I'll leave it till later, because there's little
  # value in testing it now, and I'm not quite sure how I'll do it.
end

# random helpers
When(/I seed the rand method with "([\d]+)"/) do |seed|
  srand(Integer(seed))
end

Then(/random_string should return "(.+)"/) do |expected|
  assert_equal(random_string, expected)
end

Then(/random_string of length ([\d]+) should return "(.+)"/
    ) do |length, expected|
  length_arg = Integer(length)

  ret_val = random_string(length: length_arg)

  assert_equal(ret_val, expected)
  assert_equal(ret_val.length, length_arg)
end

Then(%r{random_string w\/o (lower_case|upper_case|numbers) should return "(.+)"}
    ) do |exclude, expected|
  options = {
    lower_case: exclude == 'lower_case' ? false : true,
    upper_case: exclude == 'upper_case' ? false : true,
    numbers: exclude == 'numbers' ? false : true
  }
  assert_equal(random_string(options), expected)
end

Then(/random_string with special should return "(.+)"/) do |expected|
  assert_equal(random_string(length: 32, lower_case: false, special: true),
               expected)
end

Then(/random_string without any classes should error/) do
  begin
    random_string(8, lower_case: false, upper_case: false, numbers: false)
  rescue StandardError
    true
  else
    msg = 'No exception caught when random_string was called without classes.'
    fail Minitest::Assertion, msg
  end
end

Then(/I reset the random seed to the current timestamp/) do
  srand(Time.now.to_i)
end

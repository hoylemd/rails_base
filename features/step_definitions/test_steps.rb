Then(/I test my assert_element_present helper/) do
  # TODO: write this test. I'll leave it till later, because there's little
  # value in testing it now, and I'm not quite sure how I'll do it.
end

Then(/I test my assert_gt helper$/) do
  assert_gt 5, 2

  begin
    assert_gt 4, 4
  rescue Minitest::Assertion
    true
  end

  begin
    assert_gt 2, 18
  rescue Minitest::Assertion
    true
  end
end

Then(/I test my assert_lt helper$/) do
  assert_lt 5, 9

  begin
    assert_lt 4, 4
  rescue Minitest::Assertion
    true
  end

  begin
    assert_lt 13, 2
  rescue Minitest::Assertion
    true
  end
end

Then(/I test my assert_gte helper$/) do
  assert_gte 5, 2
  assert_gte 4, 4

  begin
    assert_gte 2, 18
  rescue Minitest::Assertion
    true
  end
end

Then(/I test my assert_lte helper$/) do
  assert_lte 5, 9
  assert_lte 4, 4

  begin
    assert_lte 13, 2
  rescue Minitest::Assertion
    true
  end
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

def _count_elements_with_attributes_msg(selector, atts, found, count = nil)
  if count
    "Expected exactly #{count} #{selector} elements with " \
      "#{_attributes_hash_to_str(atts)} specified, but found #{found}"
  else
    "Did not find any #{selector} elements with " \
      "#{_attributes_hash_to_str(atts)} specified"
  end
end

def test_element_has_attributes(element, attributes)
  passing = true
  attributes.each do |attribute|
    break unless passing
    key, val = attribute
    value = element[key]
    passing = false unless val.is_a?(Regexp) ? val.match(value) : val == value
  end
  passing
end

def find_all_with_attributes(selector, attributes, options = {})
  candidates = find_all(selector, options)
  candidates.select do |candidate|
    test_element_has_attributes(candidate, attributes)
  end
end

def find_with_assert(*args)
  message = args.last.is_a?(String) ? args.pop : nil

  matches = find_all(*args)
  assert(matches && !matches.empty?,
         message || "No element matching #{selector} was found")
  matches
end

def assert_see_links(page_name, count)
  href = page_known?(page_name) ? page_mappings[page_name] : page_name

  begin
    if href.is_a? Regexp
      assert_elements_with_attributes('a', count)
    else
      assert page.has_link?('', href: href, count: count)
    end
  rescue Minitest::Assertion => e
    message = "Should see exactly #{count} links to #{href}" \
              "#{message}, found #{page.find_all(:link, '', href: href).count}"
    raise e, message
  end
end

Then(/I should( not)? see a link to the (.*) page$/) do |negate, page_name|
  assert_see_links(page_name, negate ? 0 : 1)
end

Then(/I should see ([0-9]+) links to the (.*) page$/) do |count, page_name|
  assert_see_links page_name, count.to_i
end

Then(/The page title should be "(.*)"$/) do |page_title|
  assert_equal page.title, page_title
end

def _attributes_hash_to_str(attributes)
  attributes.keys.join ', '
end

def _assert_see_img_message(selector, src, count, found)
  if count
    msg += "Expected exactly #{count} img tags with #{selector}"
    msg += ' and specified src' if src
    msg += ", but found #{found}"
  else
    msg = "Did not find any img tags with #{selector}"
    msg += ' and specified src' if src
  end
  msg
end

# valid options:
#   src: expected src of the expected img
#   count: expected number of specified img tags. If omitted, will pass for any
#     number > 0
def assert_see_img_with_src(src, options = {})
  selector = options[:selector] ? options.delete(:selector) : 'img'

  count = options[:count]

  matches = find_all_with_attributes(selector, { src: src }, options)
  found = matches.length

  msg = _assert_see_img_message selector, src, count, found
  assert(count ? found == count : found > 0, msg)
end

# TODO: this is a bad step definition, but I can't think of a better way to do
#  it.
Then(/I should see an img with src="(.*)"$/) do |src|
  assert_see_img_with_src src
end
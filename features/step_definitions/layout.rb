def assert_see_links(page_name, count)
  href = page_known?(page_name) ? page_mappings[page_name] : page_name

  found = page.find_all(:link, '', href: href).count
  assert found == count, "Should see exactly #{count} links to #{href} " \
                         ", found #{found}"
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

# options are passed directly to find_all()
def find_all_with_attributes(selector, attributes, options = {})
  candidates = find_all(selector, options)

  candidates.select do |candidate|
    test_element_has_attributes(candidate, attributes)
  end
end

def _attributes_hash_to_str(attributes)
  attributes.keys.join ', '
end

def count_elements_with_attributes_msg(selector, atts, found, count = nil)
  if count
    "Expected exactly #{count} #{selector} elements with " \
      "specified #{_attributes_hash_to_str(atts)}, but found #{found}"
  else
    "Did not find any #{selector} elements with " \
      "specified #{_attributes_hash_to_str(atts)}"
  end
end

# valid options:
#   selector: custom css selector to select candidate elements by. default 'img'
# remaining options are passed to find_all
def assert_see_img_with_src(src, options = {})
  selector = options[:selector] ? options.delete(:selector) : 'img'
  count = options[:count]
  attributes = { src: src }

  matches = find_all_with_attributes(selector, attributes, options)
  found = matches.length

  msg = count_elements_with_attributes_msg(selector, attributes, found, count)
  assert(count ? found == count : found > 0, msg)
end

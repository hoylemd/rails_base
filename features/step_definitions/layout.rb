def assert_see_links(page_name, count)
  href = page_known?(page_name) ? page_mappings[page_name] : page_name

  begin
    assert page.has_link?('', href: href, count: count)
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
  assert_see_links page_name, count.to_s
end

Then(/The page title should be "(.*)"$/) do |page_title|
  assert_equal page.title, page_title
end

def find_with_assert(*args)
  message = args.last.is_a?(String) ? args.pop : nil

  matches = find_all(*args)
  assert(matches && !matches.empty?,
         message || "No element matching #{selector} was found")
  matches
end

def count_elements_with_attributes(elements, attributes)
  count = 0
  elements.each do |element|
    attributes.each do |attribute|
      count += 1 if element[attribute[0]].end_with? attribute[1]
    end
  end

  count
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
def assert_see_img(selector, options)
  used_selector = selector.start_with?('img') ? selector : "img#{selector}"
  src = options[:src]
  count = options[:count]

  matches = find_with_assert(used_selector,
                             "No img tag matching #{selector} was found")

  found = count_elements_with_attributes(matches, src ? { src: src } : {})

  msg = _assert_see_img_message selector, src, count, found
  assert(count ? found == count : found > 0, msg)
end

# TODO: this is a bad step definition, but I can't think of a better way to do
#  it.
Then(/I should see an img with src="(.*)"$/) do |src|
  assert_see_img '', src: src
end

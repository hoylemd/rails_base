Then(/I should see my gravatar$/) do
  gravatar_id = Digest::MD5.hexdigest(@current_email.downcase)
  url = "https://secure.gravatar.com/avatar/#{gravatar_id}?size=50"
  assert_see_img '.gravatar', src: url
end

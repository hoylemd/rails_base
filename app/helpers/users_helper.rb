module UsersHelper
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    size = options[:size]
    url = "https://secure.gravatar.com/avatar/#{gravatar_id}?size=#{size}"
    image_tag url, alt: user.name, class: 'gravatar'
  end
end

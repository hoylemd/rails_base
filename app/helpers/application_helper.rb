module ApplicationHelper
  def app_name
    # TODO: change this to your app's name
    'Rails Base'
  end

  # Returns the full title on a per-page basis
  def full_title(page_title = '')
    if page_title.empty?
      app_name
    else
      page_title + ' | ' + app_name
    end
  end
end

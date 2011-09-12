module ApplicationHelper
  def flash_tag
    unless flash.empty?
      flash.each do |k, v|
        return content_tag(:div, v, :class => [k, :flash])
      end
    end
  end
  
  def page_update_info_tag(page)
    user, dt = nil, nil
    if page.histories.empty?
      user = page.user
      dt = page.created_at
    else
      history = page.histories.first
      user = history.user
      dt = history.created_at
    end
    raw("Last update by #{content_tag(:strong, user.name)} on #{content_tag(:strong, dt.to_s(:short))}")
  end
end

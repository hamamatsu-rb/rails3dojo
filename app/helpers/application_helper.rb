module ApplicationHelper
  def flash_tag
    unless flash.empty?
      flash.each do |k, v|
        return content_tag(:div, v, :class => [k, :flash])
      end
    end
  end
end

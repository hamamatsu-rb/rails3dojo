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
  
  def markdown(text)
    text.gsub!(/\[\[(.+)\]\]/, '[\1](/\1)')
    options = [:hard_wrap, :filter_html, :autolink, :fenced_code, :gh_blockcode]
    syntax_highligher(Redcarpet.new(text, *options).to_html).html_safe
  end
  
  def syntax_highligher(html)
    doc = Nokogiri::HTML(html)
    doc.search("//pre[@lang]").each do |pre|
      pre.replace Albino.colorize(pre.text.rstrip, pre[:lang])
    end
    doc.to_s
  end
end

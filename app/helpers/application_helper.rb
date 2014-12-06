module ApplicationHelper
  include AAFServiceBase::Helpers::LayoutHelper
  include AAFServiceBase::Helpers::NavHelper

  def environment_string
    'Development'
  end

  def if_permitted(action)
    yield if @subject && @subject.permits?(action)
  end

  def page_header(header, subheader = nil)
    content_tag('h2', class: 'ui header') do
      concat(header)
      concat(content_tag('div', subheader, class: 'sub header')) if subheader
    end
  end

  def yes_no_string(boolean)
    boolean ? 'Yes' : 'No'
  end
end

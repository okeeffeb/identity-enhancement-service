module ApplicationHelper
  include Lipstick::Helpers::LayoutHelper
  include Lipstick::Helpers::NavHelper
  include Lipstick::Helpers::FormHelper

  def environment_string
    'Development'
  end

  def markdown_to_html(input)
    Kramdown::Document.new(input).to_html.html_safe
  end
end

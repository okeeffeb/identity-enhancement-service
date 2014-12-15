module ApplicationHelper
  include Lipstick::Helpers::LayoutHelper
  include Lipstick::Helpers::NavHelper
  include Lipstick::Helpers::FormHelper

  def environment_string
    'Development'
  end

  def if_permitted(action)
    yield if @subject && @subject.permits?(action)
  end
end

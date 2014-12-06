module ApplicationHelper
  include AAFServiceBase::Helpers::LayoutHelper
  include AAFServiceBase::Helpers::NavHelper

  def environment_string
    'Development'
  end

  def if_permitted(action)
    yield if @subject && @subject.permits?(action)
  end
end

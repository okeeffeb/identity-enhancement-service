module ApplicationHelper
  include AAFServiceBase::Helpers::LayoutHelper
  include AAFServiceBase::Helpers::NavHelper

  def environment_string
    'Development'
  end
end

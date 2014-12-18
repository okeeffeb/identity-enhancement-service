module PermissionsHelper
  def if_permitted(action)
    yield if @subject && @subject.permits?(action)
  end

  # TODO: Remove if not used.
  def unless_permitted(action)
    yield unless @subject && @subject.permits?(action)
  end
end

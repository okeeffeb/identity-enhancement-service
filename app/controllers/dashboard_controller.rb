class DashboardController < ApplicationController
  def index
    public_action
    @provider_roles = @subject.roles.group_by(&:provider)
    @provided_attributes =
      @subject.provided_attributes.includes(
        permitted_attribute: [:provider, :available_attribute])
  end
end

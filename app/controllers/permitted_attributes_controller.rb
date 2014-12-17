class PermittedAttributesController < ApplicationController
  before_action :require_subject
  before_action { @provider = Provider.find(params[:provider_id]) }

  def index
    check_access!('admin:permitted_attributes:list')
    @permitted_attributes = @provider.permitted_attributes.all
    already_assigned = @permitted_attributes.map(&:available_attribute)
    @available_attributes = AvailableAttribute.all - already_assigned
  end

  def create
    check_access!('admin:permitted_attributes:create')
    audit_attrs = { audit_comment: 'Added via admin interface' }
    @provider.permitted_attributes
      .create!(permitted_attribute_params.merge(audit_attrs))
    redirect_to provider_permitted_attributes_path(@provider)
  end

  def destroy
    check_access!('admin:permitted_attributes:delete')
    @permitted_attribute = @provider.permitted_attributes.find(params[:id])
    @permitted_attribute.audit_comment = 'Removed via admin interface'
    @permitted_attribute.destroy!
    redirect_to provider_permitted_attributes_path(@provider)
  end

  private

  def permitted_attribute_params
    params.require(:permitted_attribute).permit(:available_attribute_id)
  end
end

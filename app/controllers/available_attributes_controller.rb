class AvailableAttributesController < ApplicationController
  before_action :require_subject

  def index
    check_access!('admin:attributes:list')
    @attributes = AvailableAttribute.all
  end

  def new
    check_access!('admin:attributes:create')
    @attribute = AvailableAttribute.new
  end

  def create
    check_access!('admin:attributes:create')
    audit_attrs = { audit_comment: 'Created attribute from admin interface' }
    @attribute = AvailableAttribute.create!(
      audit_attrs.merge(available_attribute_params))
    redirect_to available_attributes_path
  end

  def edit
    check_access!('admin:attributes:update')
    @attribute = AvailableAttribute.find(params[:id])
  end

  def update
    check_access!('admin:attributes:update')
    @attribute = AvailableAttribute.find(params[:id])
    audit_attrs = { audit_comment: 'Edited attribute from admin interface' }
    @attribute.update_attributes!(audit_attrs.merge(available_attribute_params))
    redirect_to(available_attributes_path)
  end

  def show
    check_access!('admin:attributes:read')
    @attribute = AvailableAttribute.find(params[:id])
  end

  def destroy
    check_access!('admin:attributes:delete')
    @attribute = AvailableAttribute.find(params[:id])
    @attribute.audit_comment = 'Deleted attribute from admin interface'
    @attribute.destroy!
    redirect_to available_attributes_path
  end

  def audits
    check_access!('admin:attributes:audit')
    if params[:id]
      @attribute = AvailableAttribute.find(params[:id])
      @audits = AvailableAttribute.audits.where(auditable_id: params[:id])
    else
      @audits = AvailableAttribute.audits.all
    end
  end

  private

  def available_attribute_params
    params.require(:available_attribute).permit(:name, :value, :description)
  end
end

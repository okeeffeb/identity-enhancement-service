class ProvidedAttributesController < ApplicationController
  NotPermitted = Class.new(StandardError)
  private_constant :NotPermitted
  rescue_from NotPermitted, with: :bad_request

  before_action :require_subject
  before_action { @provider = Provider.find(params[:provider_id]) }

  def index
    check_access!("providers:#{@provider.id}:attributes:list")
    @objects = Subject.all
    @provided_attributes =
      ProvidedAttribute.joins(:permitted_attribute)
      .where('permitted_attributes.provider_id' => @provider.id)
  end

  def new
    check_access!("providers:#{@provider.id}:attributes:create")
    @object = Subject.find(params[:subject_id])
    @provided_attributes = @object.provided_attributes.for_provider(@provider)
    ids = @provided_attributes.map(&:permitted_attribute_id)
    @permitted_attributes = @provider.permitted_attributes
                            .reject { |a| ids.include?(a.id) }
  end

  def create
    check_access!("providers:#{@provider.id}:attributes:create")

    attrs = provided_attribute_params.merge(attribute_attrs)
    attrs.merge!(audit_comment: 'Provided attribute via web interface')
    @provided_attribute = permitted_attribute.provided_attributes
                          .create!(attrs)

    redirect_to provider_provided_attributes_path(@provider)
  end

  def destroy
    check_access!("providers:#{@provider.id}:attributes:delete")
    scope = ProvidedAttribute.joins(:permitted_attribute)
            .where('permitted_attributes.provider_id' => @provider.id)
    @provided_attribute = scope.find(params[:id])
    @provided_attribute.audit_comment = 'Revoked attribute via web interface'
    @provided_attribute.destroy!
    redirect_to provider_provided_attributes_path(@provider)
  end

  private

  def permitted_attribute
    id = provided_attribute_params[:permitted_attribute_id]
    @permitted_attribute ||= @provider.permitted_attributes.find(id)
  rescue ActiveRecord::RecordNotFound
    raise NotPermitted
  end

  def attribute_attrs
    attribute = permitted_attribute.available_attribute
    { name: attribute.name, value: attribute.value }
  end

  def provided_attribute_params
    params.require(:provided_attribute)
      .permit(:subject_id, :permitted_attribute_id)
  end
end

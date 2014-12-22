class ProvidersController < ApplicationController
  def index
    check_access!('providers:list')
    @providers = Provider.all
  end

  def new
    check_access!('providers:create')
    @provider = Provider.new
  end

  def create
    check_access!('providers:create')
    audit_attrs = { audit_comment: 'Created new provider from admin interface' }
    Provider.transaction do
      @provider = Provider.create!(provider_params.merge(audit_attrs))
      @provider.create_default_roles
    end

    flash[:success] = "Created provider: #{@provider.name}"

    redirect_to providers_path
  end

  def show
    check_access!("providers:#{params[:id]}:read")
    @provider = Provider.find(params[:id])
  end

  def edit
    check_access!("providers:#{params[:id]}:update")
    @provider = Provider.find(params[:id])
  end

  def update
    check_access!("providers:#{params[:id]}:update")
    audit_attrs = { audit_comment: 'Updated provider from admin interface' }
    @provider = Provider.find(params[:id])
    @provider.update_attributes!(provider_params.merge(audit_attrs))

    flash[:success] = "Updated provider: #{@provider.name}"
    redirect_to providers_path
  end

  def destroy
    check_access!('providers:delete')
    @provider = Provider.find(params[:id])
    @provider.audit_comment = 'Destroyed provider from admin interface'
    @provider.destroy!

    flash[:success] = "Deleted provider: #{@provider.name}"

    redirect_to providers_path
  end

  private

  def provider_params
    params.require(:provider).permit(:name, :description, :identifier)
  end
end

class ProvidersController < ApplicationController
  before_action :require_subject

  def index
    check_access!('admin:providers:list')
    @providers = Provider.all
  end

  def new
    check_access!('admin:providers:create')
    @provider = Provider.new
  end

  def create
    check_access!('admin:providers:create')
    audit_attrs = { audit_comment: 'Created new provider from admin interface' }
    @provider = Provider.create!(provider_params.merge(audit_attrs))
    redirect_to providers_path
  end

  def show
    check_access!('admin:providers:read')
    @provider = Provider.find(params[:id])
  end

  def edit
    check_access!('admin:providers:update')
    @provider = Provider.find(params[:id])
  end

  def update
    check_access!('admin:providers:update')
    audit_attrs = { audit_comment: 'Updated provider from admin interface' }
    @provider = Provider.find(params[:id])
    @provider.update_attributes!(provider_params.merge(audit_attrs))
    redirect_to providers_path
  end

  def destroy
    check_access!('admin:providers:delete')
    @provider = Provider.find(params[:id])
    @provider.audit_comment = 'Destroyed provider from admin interface'
    @provider.destroy!
    redirect_to providers_path
  end

  private

  def provider_params
    params.require(:provider).permit(:name, :description, :identifier)
  end
end

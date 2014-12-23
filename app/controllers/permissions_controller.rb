class PermissionsController < ApplicationController
  before_action do
    @provider = Provider.find(params[:provider_id])
    @role = @provider.roles.find(params[:role_id])
  end

  def index
    check_access!('admin:roles:read')
    @permissions = @role.permissions.all
    @new_permission = @role.permissions.build
  end

  def create
    check_access!('admin:roles:update')

    audit_attrs = { audit_comment: 'Added permission via admin interface' }
    permission = @role.permissions.create!(permission_params.merge(audit_attrs))

    flash[:success] = "Added permission: #{permission.value}"
    redirect_to(provider_role_permissions_path(@provider, @role))
  end

  def destroy
    check_access!('admin:roles:update')

    @permission = @role.permissions.find(params[:id])
    @permission.audit_comment = 'Removed permission via admin interface'
    @permission.destroy!

    flash[:success] = "Removed permission: #{@permission.value}"
    redirect_to(provider_role_permissions_path(@provider, @role))
  end

  private

  def permission_params
    params.require(:permission).permit(:value)
  end
end

class APISubjectRoleAssignmentsController < ApplicationController
  before_action do
    @provider = Provider.find(params[:provider_id])
    @role = Role.find(params[:role_id])
  end

  def new
    check_access!("providers:#{@provider.id}:roles:grant")
    @api_subjects = APISubject.all
    @assoc = @role.api_subject_role_assignments.new
  end

  def create
    check_access!("providers:#{@provider.id}:roles:grant")
    audit_attrs = { audit_comment: 'Granted role from providers interface' }
    @assoc = @role.api_subject_role_assignments
             .create!(assoc_params.merge(audit_attrs))
    redirect_to(provider_role_path(@provider, @role))
  end

  def destroy
    check_access!("providers:#{@provider.id}:roles:revoke")
    @assoc = @role.api_subject_role_assignments.find(params[:id])
    @assoc.audit_comment = 'Revoked role from providers interface'
    @assoc.destroy!
    redirect_to(provider_role_path(@provider, @role))
  end

  private

  def assoc_params
    params.require(:api_subject_role_assignment).permit(:api_subject_id)
  end
end

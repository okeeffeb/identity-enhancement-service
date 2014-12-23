class SubjectRoleAssignmentsController < ApplicationController
  before_action do
    @provider = Provider.find(params[:provider_id])
    @role = Role.find(params[:role_id])
  end

  def new
    check_access!("providers:#{@provider.id}:roles:grant")
    # TODO: Make this scale better by using a search function instead.
    @subjects = Subject.all
    @assoc = @role.subject_role_assignments.new
  end

  def create
    check_access!("providers:#{@provider.id}:roles:grant")
    audit_attrs = { audit_comment: 'Granted role from providers interface' }
    @assoc = @role.subject_role_assignments
             .create!(assoc_params.merge(audit_attrs))

    flash[:success] = creation_message(@assoc)

    redirect_to(provider_role_path(@provider, @role))
  end

  def destroy
    check_access!("providers:#{@provider.id}:roles:revoke")
    @assoc = @role.subject_role_assignments.find(params[:id])
    @assoc.audit_comment = 'Revoked role from providers interface'
    @assoc.destroy!

    flash[:success] = deletion_message(@assoc)

    redirect_to(provider_role_path(@provider, @role))
  end

  private

  def assoc_params
    params.require(:subject_role_assignment).permit(:subject_id)
  end

  def creation_message(assoc)
    "Granted #{@role.name} at #{@provider.name} to #{assoc.subject.name}"
  end

  def deletion_message(assoc)
    "Revoked #{@role.name} at #{@provider.name} from #{assoc.subject.name}"
  end
end

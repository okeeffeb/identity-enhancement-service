class InvitationsController < ApplicationController
  before_action :require_subject, only: %i(index create)

  def index
    check_access!('admin:invitations:list')
    @invitations = Invitation.all
  end

  def create
    check_access!('admin:invitations:create')

    subject = Subject.create(params.require(:invitation).permit(:name, :mail))
    Provider.find(params[:invitation][:provider_id]).invite(subject)

    redirect_to(:invitations)
  end

  def accept
    public_action

    Invitation.available.where(identifier: params[:identifier]).first!
    session[:invite] = params[:identifier]
    redirect_to('/auth/login')
  end
end

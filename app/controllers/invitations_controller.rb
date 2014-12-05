class InvitationsController < ApplicationController
  before_action :require_subject, only: %i(index create)

  def index
    check_access!('admin:invitations:list')
    @invitations = Invitation.all
  end

  def create
    check_access!('admin:invitations:create')

    attrs = params.require(:invitation).permit(:name, :mail)
            .merge(audit_comment: 'Created incomplete Subject for Invitation')

    provider = Provider.find(params[:invitation][:provider_id])
    invitation = provider.invite(Subject.create!(attrs))
    deliver(invitation)

    redirect_to(:invitations)
  end

  def show
    public_action
    @invitation = Invitation.where(identifier: params[:identifier]).first!

    render('used') && return if @invitation.used?
    render('expired') && return if @invitation.expired?
  end

  def accept
    public_action

    Invitation.available.where(identifier: params[:identifier]).first!
    session[:invite] = params[:identifier]
    redirect_to('/auth/login')
  end

  private

  def deliver(invitation)
    Mail.deliver(to: invitation.mail,
                 from: Rails.application.config.ide_service.mail.from,
                 subject: 'Invitation to AAF Identity Enhancement',
                 body: email_message(invitation).render)

    self
  end

  def email_message(invitation)
    AAFServiceBase::EmailMessage.new(title: 'AAF Identity Enhancement',
                                     image_url: 'http://example.com',
                                     content: email_body(invitation))
  end

  EMAIL_BODY = <<-EOF.gsub(/^\s+\|/, '')
    |You have been invited to AAF Identity Enhancement, so that your identity
    |can be verified for access to research services.
    |
    |Please visit the following link to accept the invite and get started:
    |
    |%<url>
    |
    |Regards,<br/>
    |AAF Team
  EOF

  def email_body(invitation)
    format(EMAIL_BODY, url: accept_invitations_url(invitation))
  end
end

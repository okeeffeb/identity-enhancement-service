class InvitationsController < ApplicationController
  before_action :require_subject, only: %i(index new create)

  before_action do
    @provider = Provider.find(params[:provider_id]) if params[:provider_id]
  end

  def index
    check_access!('admin:invitations:list')
    @invitations = Invitation.all
    @providers = Provider.all
  end

  def new
    check_access!("providers:#{@provider.id}:invitations:create")
    @invitation = Invitation.new
  end

  def create
    check_access!("providers:#{@provider.id}:invitations:create")
    create_invitation(params.require(:invitation).permit(:name, :mail))
    redirect_to(provider_provided_attributes_path(@provider))
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

  def create_invitation(subject_attrs)
    Invitation.transaction do
      audit_attrs = {
        audit_comment: 'Created incomplete Subject for Invitation'
      }

      subject = Subject.create!(subject_attrs.merge(audit_attrs))
      invitation = @provider.invite(subject)
      deliver(invitation)
    end
  end

  def deliver(invitation)
    Mail.deliver(to: invitation.mail,
                 from: Rails.application.config.ide_service.mail[:from],
                 subject: 'Invitation to AAF Identity Enhancement',
                 body: email_message(invitation).render,
                 content_type: 'text/html; charset=UTF-8')

    self
  end

  def email_message(invitation)
    Lipstick::EmailMessage.new(title: 'AAF Identity Enhancement',
                               image_url: 'http://example.com',
                               content: email_body(invitation))
  end

  EMAIL_BODY = <<-EOF.gsub(/^\s+\|/, '')
    |You have been invited to AAF Identity Enhancement, so that your identity
    |can be verified to provide access to more research services.
    |
    |Please visit the following link to accept the invite and get started:
    |
    |%{url}
    |
    |Regards,<br/>
    |AAF Team
  EOF

  def email_body(invitation)
    format(EMAIL_BODY,
           url: accept_invitations_url(identifier: invitation.identifier))
  end
end

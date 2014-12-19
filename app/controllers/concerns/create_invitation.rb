module CreateInvitation
  def create_invitation(provider, subject_attrs)
    Invitation.transaction do
      audit_attrs = {
        audit_comment: 'Created incomplete Subject for Invitation'
      }

      subject = Subject.create!(subject_attrs.merge(audit_attrs))
      invitation = provider.invite(subject)
      deliver(invitation)
      subject
    end
  end

  private

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

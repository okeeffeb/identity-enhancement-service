class Provider < ActiveRecord::Base
  audited comment_required: true
  has_associated_audits

  has_many :roles
  has_many :permitted_attributes
  has_many :provided_attributes
  has_many :api_subjects

  validates :name, :description, presence: true
  validates :identifier, presence: true, format: { with: /\A[\w-]{1,40}\z/ }

  has_many :invitations

  def self.identifier_prefix
    Rails.application.config.ide_service.provider_prefix
  end

  def self.lookup(identifier)
    re = /\A#{identifier_prefix}:(.*)\z/
    find_by_identifier(Regexp.last_match[1]) if re.match(identifier)
  end

  def full_identifier
    [Provider.identifier_prefix, identifier].join(':')
  end

  def invite(subject)
    identifier = SecureRandom.urlsafe_base64(19)

    message = "Created invitation for #{subject.name}"

    attrs = { subject_id: subject.id, identifier: identifier,
              name: subject.name, mail: subject.mail,
              expires: 1.month.from_now, audit_comment: message }

    invitations.create!(attrs)
  end
end

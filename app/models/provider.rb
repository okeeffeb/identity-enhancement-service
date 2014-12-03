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

  def invite(subject)
    identifier = SecureRandom.urlsafe_base64(19)

    attrs = { subject_id: subject.id, identifier: identifier,
              name: subject.name, mail: subject.mail,
              expires: 1.month.from_now }

    invitations.create_with(attrs).find_or_create_by!({})
  end
end

class Subject < ActiveRecord::Base
  audited comment_required: true
  has_associated_audits

  include Accession::Principal

  has_many :subject_role_assignments, dependent: :destroy
  has_many :roles, through: :subject_role_assignments
  has_many :provided_attributes, dependent: :destroy
  has_many :invitations, dependent: :destroy

  validates :name, :mail, presence: true
  validates :targeted_id, :shared_token, presence: true, if: :complete?
  validates :complete, :enabled, inclusion: { in: [true, false] }

  def permissions
    subject_role_assignments.flat_map { |ra| ra.role.permissions.map(&:value) }
  end

  def accept(invitation, attrs)
    transaction do
      message = 'Provisioned account via invitation'
      update_attributes!(attrs.merge(audit_comment: message, complete: true))

      invitation.update_attributes!(used: true,
                                    audit_comment: "Accepted by #{name}")
    end
  end

  def functioning?
    enabled?
  end
end

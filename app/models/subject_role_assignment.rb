class SubjectRoleAssignment < ActiveRecord::Base
  audited comment_required: true, associated_with: :subject

  belongs_to :subject
  belongs_to :role

  validates :subject, :role, presence: true
end

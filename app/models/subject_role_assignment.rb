class SubjectRoleAssignment < ActiveRecord::Base
  # audited under subject

  belongs_to :subject
  belongs_to :role

  validates :subject, :role, presence: true
end

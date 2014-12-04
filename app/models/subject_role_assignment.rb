class SubjectRoleAssignment < ActiveRecord::Base
  belongs_to :subject
  belongs_to :role

  validates :subject, :role, presence: true
end

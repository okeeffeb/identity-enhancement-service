class APISubjectRoleAssignment < ActiveRecord::Base
  # audited under api_subject

  belongs_to :api_subject
  belongs_to :role

  validates :api_subject, :role, presence: true
end

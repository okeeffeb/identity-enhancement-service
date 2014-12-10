class APISubjectRoleAssignment < ActiveRecord::Base
  audited comment_required: true, associated_with: :api_subject

  belongs_to :api_subject
  belongs_to :role

  validates :api_subject, :role, presence: true
end

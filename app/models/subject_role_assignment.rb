class SubjectRoleAssignment < ActiveRecord::Base
  belongs_to :subject
  belongs_to :role
end

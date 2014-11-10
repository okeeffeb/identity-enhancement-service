class Subject < ActiveRecord::Base
  has_many :subject_role_assignments
  has_many :roles, through: :subject_role_assignments
  has_many :provided_attributes
end

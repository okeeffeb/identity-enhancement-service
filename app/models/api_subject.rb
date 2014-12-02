class APISubject < ActiveRecord::Base
  belongs_to :provider

  has_many :api_subject_role_assignments
  has_many :roles, through: :api_subject_role_assignments
end

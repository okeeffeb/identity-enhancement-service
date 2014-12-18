class Role < ActiveRecord::Base
  audited comment_required: true, associated_with: :provider
  has_associated_audits

  belongs_to :provider

  has_many :permissions
  has_many :subject_role_assignments
  has_many :api_subject_role_assignments

  has_many :subjects, through: :subject_role_assignments
  has_many :api_subjects, through: :api_subject_role_assignments

  validates :provider, :name, presence: true
end

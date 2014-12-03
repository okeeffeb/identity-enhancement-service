class Subject < ActiveRecord::Base
  audited comment_required: false
  has_associated_audits

  include Accession::Principal

  has_many :subject_role_assignments
  has_many :roles, through: :subject_role_assignments
  has_many :provided_attributes

  validates :name, :mail, presence: true
  validates :targeted_id, :shared_token, presence: true, if: :complete?

  def permissions
    subject_role_assignments.flat_map { |ra| ra.role.permissions.map(&:value) }
  end
end

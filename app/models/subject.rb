class Subject < ActiveRecord::Base
  include Accession::Principal

  has_many :subject_role_assignments
  has_many :roles, through: :subject_role_assignments
  has_many :provided_attributes

  def permissions
    subject_role_assignments.flat_map { |ra| ra.role.permissions.map(&:value) }
  end
end

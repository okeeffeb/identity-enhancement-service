class APISubject < ActiveRecord::Base
  include Accession::Principal

  audited comment_required: true
  has_associated_audits

  belongs_to :provider

  has_many :api_subject_role_assignments, dependent: :destroy
  has_many :roles, through: :api_subject_role_assignments

  valhammer

  validates :x509_cn, format: /\A[\w-]+\z/

  def permissions
    roles.flat_map { |role| role.permissions.map(&:value) }
  end

  def functioning?
    enabled?
  end
end

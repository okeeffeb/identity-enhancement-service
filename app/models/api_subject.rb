class APISubject < ActiveRecord::Base
  include Accession::Principal

  audited comment_required: true
  has_associated_audits

  belongs_to :provider

  has_many :api_subject_role_assignments, dependent: :destroy
  has_many :roles, through: :api_subject_role_assignments

  validates :provider, :description, :contact_name, :contact_mail,
            presence: true
  validates :x509_cn, presence: true, format: { with: /\A[\w-]+\z/ },
                      uniqueness: true
  validates :enabled, inclusion: { in: [true, false] }

  def permissions
    roles.flat_map { |role| role.permissions.map(&:value) }
  end

  def functioning?
    enabled?
  end
end

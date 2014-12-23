class AvailableAttribute < ActiveRecord::Base
  audited comment_required: true

  has_many :permitted_attributes, dependent: :restrict_with_error

  validates :description, presence: true
  validates :name, presence: true, inclusion: { in: %w(eduPersonEntitlement) }

  validates :value, presence: true, format: {
    with: /\Aurn:mace:aaf\.edu\.au:ide:([\w\.-]+:)*[\w\.-]+\z/ }

  def initialize(*)
    super
    self.name ||= 'eduPersonEntitlement'
    self.value ||= 'urn:mace:aaf.edu.au:ide:'
  end

  def self.audits
    Audited.audit_class.where(auditable_type: name)
  end
end

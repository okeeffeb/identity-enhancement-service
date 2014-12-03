class Role < ActiveRecord::Base
  audited comment_required: true, associated_with: :provider
  has_associated_audits

  belongs_to :provider

  has_many :permissions

  validates :provider, :name, presence: true
end

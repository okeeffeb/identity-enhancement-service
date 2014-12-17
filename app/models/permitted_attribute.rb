class PermittedAttribute < ActiveRecord::Base
  audited comment_required: true, associated_with: :provider

  belongs_to :provider
  belongs_to :available_attribute

  has_many :provided_attributes

  validates :provider, :available_attribute, presence: true
end

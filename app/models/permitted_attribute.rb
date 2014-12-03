class PermittedAttribute < ActiveRecord::Base
  # audited under provider

  belongs_to :provider
  belongs_to :available_attribute

  validates :provider, :available_attribute, presence: true
end

class PermittedAttribute < ActiveRecord::Base
  belongs_to :provider
  belongs_to :available_attribute

  validates :provider, :available_attribute, presence: true
end

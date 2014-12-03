class AvailableAttribute < ActiveRecord::Base
  has_many :permitted_attributes

  validates :description, presence: true
  validates :name, presence: true, inclusion: { in: %w(eduPersonEntitlement) }

  VALUES = %w(urn:mace:aaf.edu.au:ide:researcher:1)
  private_constant :VALUES
  validates :value, presence: true, inclusion: { in: VALUES }
end

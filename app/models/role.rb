class Role < ActiveRecord::Base
  # audited under provider

  belongs_to :provider

  has_many :permissions

  validates :provider, :name, presence: true
end

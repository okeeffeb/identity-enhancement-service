class Role < ActiveRecord::Base
  belongs_to :provider

  has_many :permissions

  validates :provider, :name, presence: true
end

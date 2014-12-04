class Provider < ActiveRecord::Base
  has_many :roles
  has_many :permitted_attributes
  has_many :provided_attributes
  has_many :api_subjects

  validates :name, :description, presence: true
  validates :identifier, presence: true, format: { with: /\A[\w-]{1,40}\z/ }
end

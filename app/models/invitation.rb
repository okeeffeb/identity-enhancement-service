class Invitation < ActiveRecord::Base
  belongs_to :provider
  belongs_to :subject

  validates :provider, :subject, :name, :mail, :expires, presence: true
  validates :identifier, presence: true, format: { with: /\A[\w-]+\z/ }
end
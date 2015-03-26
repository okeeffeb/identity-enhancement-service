class Invitation < ActiveRecord::Base
  include Lipstick::AutoValidation

  audited comment_required: true

  belongs_to :provider
  belongs_to :subject

  valhammer

  validates :identifier, format: /\A[\w-]+\z/

  validate :must_not_be_preexpired

  scope :current, -> { where(arel_table[:expires].gt(Time.now)) }
  scope :available, -> { current.where(used: false) }

  def expired?
    !used? && expires && expires < Time.now
  end

  def must_not_be_preexpired
    return if persisted?
    errors.add(:expires, 'must be in the future') if expired?
  end
end

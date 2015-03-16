class Invitation < ActiveRecord::Base
  audited comment_required: true

  belongs_to :provider
  belongs_to :subject

  valhammer

  validates :identifier, format: /\A[\w-]+\z/

  scope :current, -> { where(arel_table[:expires].gt(Time.now)) }
  scope :available, -> { current.where(used: false) }

  def expired?
    expires < Time.now
  end
end

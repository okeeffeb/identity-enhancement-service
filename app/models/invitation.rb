class Invitation < ActiveRecord::Base
  audited comment_required: true

  belongs_to :provider
  belongs_to :subject

  validates :provider, :subject, :name, :mail, :expires, presence: true
  validates :identifier, presence: true, format: { with: /\A[\w-]+\z/ },
                         uniqueness: true

  scope :current, -> { where(arel_table[:expires].gt(Time.now)) }
  scope :available, -> { current.where(used: false) }

  def expired?
    expires < Time.now
  end
end

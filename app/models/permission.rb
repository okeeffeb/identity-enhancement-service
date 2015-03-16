class Permission < ActiveRecord::Base
  audited comment_required: true, associated_with: :provider

  belongs_to :role
  delegate :provider, to: :role

  validates :role, presence: true

  # "word" in the url-safe base64 alphabet, or single '*'
  SEGMENT = /([\w-]+|\*)/
  private_constant :SEGMENT
  validates :value, presence: true, uniqueness: { scope: :role },
                    format: { with: /\A(#{SEGMENT}:)*#{SEGMENT}\z/ }
end

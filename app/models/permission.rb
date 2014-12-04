class Permission < ActiveRecord::Base
  belongs_to :role

  validates :role, presence: true

  # "word" in the url-safe base64 alphabet, or single '*'
  SEGMENT = /([\w-]+|\*)/
  private_constant :SEGMENT
  validates :value, presence: true,
                    format: { with: /\A(#{SEGMENT}:)*#{SEGMENT}\z/ }
end

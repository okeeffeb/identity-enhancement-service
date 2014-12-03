class ProvidedAttribute < ActiveRecord::Base
  audited comment_required: true, associated_with: :subject

  belongs_to :permitted_attribute
  belongs_to :subject

  validates :permitted_attribute, :subject, :name, :value, presence: true
  validate :must_match_permitted_attribute

  def must_match_permitted_attribute
    return unless permitted_attribute
    attr = permitted_attribute.available_attribute

    errors.add(:name, 'must match the permitted name') if name != attr.name
    errors.add(:value, 'must match the permitted value') if value != attr.value
  end
end

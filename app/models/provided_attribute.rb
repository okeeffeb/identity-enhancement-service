class ProvidedAttribute < ActiveRecord::Base
  belongs_to :permitted_attribute
  belongs_to :subject
end

class PermittedAttribute < ActiveRecord::Base
  belongs_to :provider
  belongs_to :available_attribute
end

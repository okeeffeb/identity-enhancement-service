class AvailableAttribute < ActiveRecord::Base
  has_many :permitted_attributes
end

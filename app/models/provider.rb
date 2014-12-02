class Provider < ActiveRecord::Base
  has_many :roles
  has_many :permitted_attributes
  has_many :provided_attributes
  has_many :api_subjects
end

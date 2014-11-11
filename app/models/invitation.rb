class Invitation < ActiveRecord::Base
  belongs_to :provider
  belongs_to :subject
end

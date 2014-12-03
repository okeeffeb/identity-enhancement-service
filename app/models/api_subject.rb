class APISubject < ActiveRecord::Base
  belongs_to :provider

  has_many :api_subject_role_assignments
  has_many :roles, through: :api_subject_role_assignments

  validates :provider, :name, :description, :contact_name, :contact_mail,
            presence: true
  validates :x509_cn, presence: true, format: { with: /\A[\w-]+\z/ }
end

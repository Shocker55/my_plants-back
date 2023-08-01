class User < ApplicationRecord
  has_one :profile
  has_many :records

  validates :uid, presence: true
end

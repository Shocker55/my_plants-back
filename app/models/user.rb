class User < ApplicationRecord
  has_one :profile
  validates :uid, presence: true
end

class User < ApplicationRecord
  has_one :profile, dependent: :destroy
  has_many :records, dependent: :destroy

  validates :uid, presence: true
end

class User < ApplicationRecord
  validates :uid, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :bio, presence: true, length: { maximum: 300 }

  enum role: { general: 0, admin: 1 }
end

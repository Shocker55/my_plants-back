class Profile < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  belongs_to :user

  validates :user_id, presence: true, uniqueness: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :bio, presence: true, length: { maximum: 300 }

  enum role: { general: 0, admin: 1}
end

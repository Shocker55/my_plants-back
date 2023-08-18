class Record < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :user
  has_many :related_records, dependent: :destroy

  validates :user_id, presence: true
  validates :title, presence: true
  validates :base, inclusion: [true, false]
end

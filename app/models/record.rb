class Record < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :user
  has_many :related_records, dependent: :destroy
  has_many :record_likes, dependent: :destroy
  has_many :record_bookmarks, dependent: :destroy
  has_many :record_comments, dependent: :destroy
  has_many :record_tags, dependent: :destroy
  has_many :tags, through: :record_tags

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 30 }
  validates :base, inclusion: [true, false]
end

class User < ApplicationRecord
  has_one :profile, dependent: :destroy
  has_many :records, dependent: :destroy
  has_many :record_likes, dependent: :destroy
  has_many :like_records, through: :record_likes, source: :record, dependent: :destroy
  has_many :record_comments, dependent: :destroy

  validates :uid, presence: true

  def like(record)
    like_records << record
  end

  def unlike(record)
    like_records.destroy(record)
  end
end

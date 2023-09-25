class Tag < ApplicationRecord
  has_many :record_tags, dependent: :destroy
  has_many :records, through: :record_tags

  validates :name, presence: true, uniqueness: true, length: { maximum: 10 }
end

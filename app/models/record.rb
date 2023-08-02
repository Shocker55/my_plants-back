class Record < ApplicationRecord
  belongs_to :user
  has_many :related_records

  validates :user_id, presence: true
  validates :title, presence: true
  validates :base, inclusion: [true, false]
end

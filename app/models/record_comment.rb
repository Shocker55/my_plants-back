class RecordComment < ApplicationRecord
  belongs_to :user
  belongs_to :record

  validates :comment, presence: true, length: { maximum: 100 }
end

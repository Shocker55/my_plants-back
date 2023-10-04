class EventComment < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :comment, presence: true, length: { maximum: 100 }
end

class RecordBookmark < ApplicationRecord
  belongs_to :user
  belongs_to :record

  validates :user_id, uniqueness: { scope: :record_id }
end

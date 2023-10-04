class RecordTag < ApplicationRecord
  belongs_to :record
  belongs_to :tag

  validates :tag_id, uniqueness: { scope: :record_id }
end

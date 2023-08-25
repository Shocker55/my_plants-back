class RelatedRecord < ApplicationRecord
  belongs_to :record

  validates :record_id, presence: true, uniqueness: { scope: :related_record_id }
  validates :related_record_id, presence: true, numericality: { greater_than: 0 }
end

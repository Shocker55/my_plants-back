class User < ApplicationRecord
  has_one :profile, dependent: :destroy
  has_many :records, dependent: :destroy
  has_many :record_likes, dependent: :destroy
  has_many :like_records, through: :record_likes, source: :record, dependent: :destroy
  has_many :record_bookmarks, dependent: :destroy
  has_many :bookmark_records, through: :record_bookmarks, source: :record, dependent: :destroy
  has_many :record_comments, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :event_bookmarks, dependent: :destroy
  has_many :bookmark_events, through: :event_bookmarks, source: :event, dependent: :destroy
  has_many :event_comments, dependent: :destroy
  has_many :event_attendees, dependent: :destroy
  has_many :attend_events, through: :event_attendees, source: :event, dependent: :destroy

  validates :uid, presence: true

  def like(record)
    like_records << record
  end

  def unlike(record)
    like_records.destroy(record)
  end

  def bookmark_record(record)
    bookmark_records << record
  end

  def unbookmark_record(record)
    bookmark_records.destroy(record)
  end

  def bookmark_event(event)
    bookmark_events << event
  end

  def unbookmark_event(event)
    bookmark_events.destroy(event)
  end

  def attend(event)
    attend_events << event
  end

  def cancel(event)
    attend_events.destroy(event)
  end
end

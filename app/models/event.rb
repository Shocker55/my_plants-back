class Event < ApplicationRecord
  belongs_to :user
  has_many :event_comments, dependent: :destroy
  has_many :event_bookmarks, dependent: :destroy
  has_many :event_attendees, dependent: :destroy
  has_many :attendees, through: :event_attendees, source: :user

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 30 }
  validates :body, presence: true, length: { maximum: 200 }
  validates :place, presence: true, length: { maximum: 50 }
  validates :official_url,
            format: { with: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/, if: :official_url_present? }
  validates_uniqueness_of :title, scope: %i[start_date place], message: 'イベントが登録されています。'
  validate :start_end_date_check

  enum date_type: { full_date: 0, month_only: 1 }

  def official_url_present?
    official_url.present?
  end

  def start_end_date_check
    if start_date && end_date && start_date > end_date
      errors.add(:end_date, "は開始日より前の日付は登録できません")
    end
  end
end

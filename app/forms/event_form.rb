class EventForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :word

  def search
    events = Event.where("end_date >= ?", Date.today).includes(
      event_bookmarks: { user: [:profile] }, user: [:profile]
    ).order(updated_at: "DESC")

    if word.present?
      return events = events.where("title LIKE ? OR body LIKE ? OR place LIKE ?", "%#{word}%", "%#{word}%", "%#{word}%")
    end

    events
  end
end

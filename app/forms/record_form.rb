class RecordForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :title, :body

  def search
    records = Record.includes(
      record_likes: { user: [:profile] }, record_bookmarks: :user, user: [:profile]
    ).order(updated_at: "DESC")
    return records = records.where("title LIKE ?", "%#{title}%") if title.present?

    return records = records.where("body LIKE ?", "%#{body}%") if body.present?

    records
  end
end

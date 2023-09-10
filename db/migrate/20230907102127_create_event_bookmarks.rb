class CreateEventBookmarks < ActiveRecord::Migration[7.0]
  def change
    create_table :event_bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
    add_index :event_bookmarks, %i[user_id event_id], unique: true
  end
end

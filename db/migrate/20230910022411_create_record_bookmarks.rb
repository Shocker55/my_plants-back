class CreateRecordBookmarks < ActiveRecord::Migration[7.0]
  def change
    create_table :record_bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :record, null: false, foreign_key: true

      t.timestamps
    end
    add_index :record_bookmarks, %i[user_id record_id], unique: true
  end
end

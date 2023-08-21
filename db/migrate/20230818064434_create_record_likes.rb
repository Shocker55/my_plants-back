class CreateRecordLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :record_likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :record, null: false, foreign_key: true

      t.timestamps
    end
    add_index :record_likes, %i[user_id record_id], unique: true
  end
end

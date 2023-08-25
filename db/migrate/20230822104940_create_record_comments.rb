class CreateRecordComments < ActiveRecord::Migration[7.0]
  def change
    create_table :record_comments do |t|
      t.text :comment, null: false
      t.references :user, null: false, foreign_key: true
      t.references :record, null: false, foreign_key: true

      t.timestamps
    end
  end
end

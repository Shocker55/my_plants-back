class CreateRecordTags < ActiveRecord::Migration[7.0]
  def change
    create_table :record_tags do |t|
      t.references :record, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
    add_index :record_tags, [:record_id, :tag_id], unique: true
  end
end

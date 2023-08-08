class CreateRelatedRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :related_records do |t|
      t.references :record, null: false, foreign_key: true
      t.integer :related_record_id, null: false

      t.timestamps
    end
    add_index :related_records, :related_record_id, unique: true
  end
end

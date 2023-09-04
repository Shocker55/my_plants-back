class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :body, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :date_type, null: false
      t.time :start_time
      t.time :end_time
      t.string :place, null: false
      t.string :official_url

      t.timestamps
    end
    add_index :events, [:title, :start_date, :place], unique: true
  end
end

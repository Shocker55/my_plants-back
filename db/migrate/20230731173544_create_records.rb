class CreateRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :records do |t|
      t.string :title, null: false
      t.text :body
      t.string :image
      t.boolean :base, default: true, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

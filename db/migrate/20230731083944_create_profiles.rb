class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.string :name,    null: false
      t.string :avatar,  null: false
      t.text :bio,       null: false
      t.integer :role, default: 0, null: false
      t.references :user, null: false, index: { unique: true }, foreign_key: true
      t.timestamps
    end
  end
end

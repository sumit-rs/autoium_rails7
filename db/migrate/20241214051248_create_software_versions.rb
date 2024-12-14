class CreateSoftwareVersions < ActiveRecord::Migration[7.2]
  def change
    create_table :software_versions do |t|
      t.string :name
      t.text :description
      t.date :release_date, null: false
      t.integer :software_type, null: false, default: 1
      t.timestamps
    end
  end
end

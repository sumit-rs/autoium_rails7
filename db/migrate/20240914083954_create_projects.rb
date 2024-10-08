class CreateProjects < ActiveRecord::Migration[7.2]
  def change
    create_table :projects do |t|

      t.string :name, null: false
      t.text :description, null: true
      t.integer :created_by, null: false
      t.boolean :save_to_s3, default: false
      t.string :s3_bucket_name, null: true
      t.text :s3_access_key, null: true
      t.text :s3_secret_key, null: true
      t.string :s3_region_name, null: true
      t.datetime :deleted_at, null: true
      t.timestamps
    end
  end
end

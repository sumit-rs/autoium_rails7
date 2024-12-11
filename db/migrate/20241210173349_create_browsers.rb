class CreateBrowsers < ActiveRecord::Migration[7.2]
  def up
    create_table :browsers do |t|
      t.string :name
      t.boolean :is_active, default: true
      t.timestamps
    end
    Browser.populate_default_data
  end

  def down
    drop_table :browsers
  end
end

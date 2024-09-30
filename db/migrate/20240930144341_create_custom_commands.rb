class CreateCustomCommands < ActiveRecord::Migration[7.2]
  def change
    create_table :custom_commands do |t|
      t.integer :environment_id, null: false
      t.string :name, null: false
      t.string :command, null: false
      t.text :additional_information
      t.timestamps
    end
  end
end

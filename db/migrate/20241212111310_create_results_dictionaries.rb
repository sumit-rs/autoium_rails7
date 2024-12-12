class CreateResultsDictionaries < ActiveRecord::Migration[7.2]
  def change
    create_table :results_dictionaries do |t|
      t.text :description
      t.timestamps
    end
  end
end

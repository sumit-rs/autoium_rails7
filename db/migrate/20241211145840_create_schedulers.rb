class CreateSchedulers < ActiveRecord::Migration[7.2]
  def change
    create_table :schedulers do |t|
      t.references :user, null: true
      t.references :test_suite, null: true
      t.references :browser, null: true
      t.integer  :number_of_times
      t.string :status
      t.timestamp :scheduled_date
      t.timestamp :completed_date
      t.boolean :record_session, default: false
      t.boolean :dependency, default: false
      t.timestamps
    end
  end
end

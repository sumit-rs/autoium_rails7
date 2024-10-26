class CreateTestCases < ActiveRecord::Migration[7.2]
  def change
    create_table :test_cases do |t|
      t.references :user, null: false, foreign_key: true
      t.references :test_suite, null: false, foreign_key: true
      t.integer :custom_command_id
      t.string :field_name
      t.string :field_type
      t.string :read_element
      t.string :input_value
      t.string :string
      t.string :action
      t.string :action_url
      t.string :base_url
      t.string :xpath
      t.string :selenium_file
      t.string :element_class
      t.string :full_xpath
      t.integer :sleeps
      t.integer :priority
      t.text  :description
      t.boolean :need_screenshot, default: false
      t.boolean :dependency, default: false
      t.boolean :new_tab, default: false
      t.boolean :enter_action, default: false
      t.boolean :javascript_conditional_enabled, default: false
      t.text  :javascript_conditional
      t.timestamps
    end
  end
end

class AddFileColunInManualCaseAndResult < ActiveRecord::Migration[7.2]
  def change
    add_column :manual_cases, :screenshot_file_location, :string, after: :url
    add_column :manual_case_results, :screenshot_file_location, :string, after: :description
  end
end

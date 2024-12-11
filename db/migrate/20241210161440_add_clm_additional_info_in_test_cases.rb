class AddClmAdditionalInfoInTestCases < ActiveRecord::Migration[7.2]
  def change
    add_column :test_cases, :additional_info, :text, after: :description
  end
end

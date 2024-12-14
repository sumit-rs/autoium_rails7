class ChangeElementClassFldTestCase < ActiveRecord::Migration[7.2]
  def change
    change_column(:test_cases, :element_class, :text)
  end
end

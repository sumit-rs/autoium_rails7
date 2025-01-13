class ChangeUrlTypeManualCase < ActiveRecord::Migration[7.2]
  def change
    change_column(:manual_cases, :url, :text)
  end
end

class AddMoreInfoClmInUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :additional_info, :text, after: :role
  end
end

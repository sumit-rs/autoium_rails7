class AddInvitationTokenDateUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :invitation_token, :string, after: :additional_info
    add_column :users, :invitation_sent, :datetime, after: :invitation_token
    remove_column :users, :admin
  end
end

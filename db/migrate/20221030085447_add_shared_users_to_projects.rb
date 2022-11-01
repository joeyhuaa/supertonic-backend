class AddSharedUsersToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :shared_users, :string, array: true, default: []
  end
end

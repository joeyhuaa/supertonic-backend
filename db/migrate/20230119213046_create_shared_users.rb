class CreateSharedUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :shared_users, project_id: :string do |t|
      t.string :username
      t.string :email
      t.string :project_id

      t.timestamps
    end
  end
end

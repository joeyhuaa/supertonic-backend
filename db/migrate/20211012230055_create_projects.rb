class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects, id: :string do |t|
      t.string :name
      t.text :description
      t.string :branches
      t.string :songs
      t.string :shared_users

      t.timestamps
      t.belongs_to :user
    end
  end
end
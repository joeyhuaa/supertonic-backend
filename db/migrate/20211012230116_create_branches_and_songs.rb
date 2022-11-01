class CreateBranchesAndSongs < ActiveRecord::Migration[6.1]
  def change
    create_table :branches, project_id: :string do |t|
      t.string :name
      t.string :songs
      t.string :project_id

      t.timestamps
    end

    create_table :songs, project_id: :string do |t|
      t.string :name
      t.string :duration
      t.string :filetype
      t.string :project_id
      t.string :url

      t.timestamps
    end

    # join table for has_many_and_belongs_to for Branch and Song
    create_table :branches_songs, :id => false do |t|
      t.belongs_to :branch
      t.belongs_to :song
    end
    
  end
end
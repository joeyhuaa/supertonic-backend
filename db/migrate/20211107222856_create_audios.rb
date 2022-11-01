class CreateAudios < ActiveRecord::Migration[6.1]
  def change
    create_table :audios do |t|
      t.string :name
      t.string :duration
      t.string :file

      t.timestamps
    end
  end
end

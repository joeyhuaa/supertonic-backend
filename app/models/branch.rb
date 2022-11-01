class Branch < ApplicationRecord
  belongs_to :project
  has_and_belongs_to_many :songs

  def addSong(song)
    self.songs.push(song)
    self.save!
  end

  def deleteSong(song)
    self.songs.delete(song)
    self.save!
  end
end

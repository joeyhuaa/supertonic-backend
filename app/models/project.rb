require 'byebug'

class Project < ApplicationRecord
  belongs_to :user
  has_many :songs, dependent: :delete_all
  has_many :branches, dependent: :delete_all

  #todo ?
  #has_many :users
  #has_one :owner

  serialize :name, JSON
  serialize :description, JSON
  serialize :shared_users

  def song_ids
    self.songs.map{|song| song.id}
  end

  def addBranch(newBranchName, sourceBranchName = nil)
    @branch = self.branches.create(created_at: Time.now)
    @branch.name = newBranchName

    if sourceBranchName
      @branch.songs = self.branches.find_by(name: sourceBranchName).songs
    end
    
    @branch.save!
    self.save!
  end

  def addSongs(files, branchName)
    files.each do |file|
      # create song and attach file to model
      @song = self.songs.create(created_at: Time.now)
      @song.file.attach(file)

      # add metadata
      song_info = AudioInfo.open(file)
      @song.name = file.original_filename
      @song.duration = song_info.length
      @song.filetype = file.content_type
      @song.save! 

      # add url
      @song.url = @song.file_url
      @song.save!

      # add song to branch
      @branch = self.branches.find_by(name: branchName)
      @branch.addSong(@song)
    end
    self.save!
  end
end

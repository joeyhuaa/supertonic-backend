#* test file

class Audio < ApplicationRecord
  has_many_attached :songs

  def song_urls
    songs.map{|s| Rails.application.routes.url_helpers.url_for(s) }
  end
end

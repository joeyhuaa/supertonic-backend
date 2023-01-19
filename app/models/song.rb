class Song < ApplicationRecord
  belongs_to :project
  has_and_belongs_to_many :branches
  has_one_attached :file

  def file_url
    Rails.application.routes.url_helpers.url_for(file) if file.attached?
  end
end
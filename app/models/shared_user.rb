# require 'byebug'

class SharedUser < ApplicationRecord
# class SharedUser < User
  belongs_to :project
end

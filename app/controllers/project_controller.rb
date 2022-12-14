# MIGRATION DB SHENANIGANS
# https://guides.rubyonrails.org/association_basics.html

# require 'byebug'

class ProjectController < ApplicationController
  include ApplicationHelper
  # skip_forgery_protection
  # skip_before_action :verify_authenticity_token, raise: false

  # ! not working...
  # skip_before_action :authenticate_user!, only: [:get]

  # POST api/projects/new
  def new
    @user = User.find(params[:userId])
    @project = @user.projects.create(id: params[:id])

    #* name
    @project.name = "Untitled Project"

    #* description
    @project.description = ""

    #* branch
    @project.addBranch('main')

    #todo - make this an array, like project.songs
    #todo - make has_many property? but then we'd have to make a new table... either shared_users or owner/editors
    @project.shared_users.push("{#{@user}}") #! not working.....

    @project.save!

    render :json => @project
  end

  # GET api/projects/:id
  def get
    @project = Project.find(params[:id])
    render :json => @project
  end

  # GET api/projects
  def get_all
    @user = User.find(params[:userId])
    render :json => @user.projects.reverse
  end

  # PUT api/projects/:id/add_songs
  def add_songs
    @project = Project.find(params[:projectId])
    @project.addSongs(params[:files], params[:branchName])
    if @project.save
      data = @project.songs.map{ |song| { name: song.name, url: song.file_url } }
      render :json => data, status: :created
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # PUT api/projects/:id/newbranch
  def new_branch
    @project = Project.find( params[:projId] )
    @project.addBranch( params[:newBranchName], params[:sourceBranchName] )
    render :json => @project
  end

  # PUT api/projects/:id/delete_branch
  def delete_branch
  end

  # DELETE api/projects/:id/delete_song
  def delete_song
    @project = Project.find(params[:projectId])
    @branch = @project.branches.find{|branch| branch.name == params[:branchName]}
    @song = Song.find(params[:songId])

    #* remove from branch if the song is in multiple branches
    #* destroy song if it's only in 1 branch
    if @song.branch_ids.size > 1
      # remove song from branch
      @branch.deleteSong(@song)
      render :json => {
        songRemoved: @song,
        status: `removed from branch "#{@branch.name}"`
      }
    else
      # destroy song
      @song.file.purge # remove file from S3
      @song.destroy
      render :json => {
        songRemoved: @song,
        status: 'destroyed'
      }
    end
  end

  # PUT api/projects/:id/replace_song
  def replace_song
    @project = Project.find(params[:projectId])
    @branch = @project.branches.find{|branch| branch.name == params[:branchName]}
    @oldSong = Song.find(params[:songId])

    #remove old song from branch
    @branch.deleteSong(@oldSong)

    #add new song to project and branch
    @project.addSongs(params[:files], params[:branchName])

    data = @project.songs.map{ |song| { name: song.name, url: song.file_url } }
    render :json => data
  end

  # DELETE api/projects/:id/destroy
  def destroy
    @project = Project.find(params[:id])
    @project.songs.each {|song| song.file.purge} # remove all song files from S3
    @project.destroy
    render :json => {status: 200}
  end

  # PUT api/projects/:id/change_name
  def change_name
    @project = Project.find(params[:id])

    if params[:name]
      @project.name = params[:name]
    end

    @project.save
    render :json => @project
  end

  #todo
  # PUT api/projects/:id/add_user
  def add_user
    @project = Project.find(params[:id])

    #add new user to project
    if params[:userId]
      @user = User.find(params[:userId])
      @project.shared_users.push(@user)
    end
  end

  private

end

# MIGRATION DB SHENANIGANS
# https://guides.rubyonrails.org/association_basics.html

# require 'byebug'

class ProjectController < ApplicationController
  include ApplicationHelper
  # skip_forgery_protection
  # skip_before_action :verify_authenticity_token, raise: false

  #! not working...
  # skip_before_action :authenticate_user!, only: [:get]

  # POST api/projects/new
  def new
    @user = User.find(params[:userId])
    @project = @user.projects.create(id: params[:id])

    #* name
    @project.name = "Untitled Project"

    #* owner
    @project.owner = @user.as_json

    #* description
    @project.description = ""

    #* branch
    @project.add_branch('main')

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
    @project.add_songs(params[:files], params[:branchName])
    if @project.save
      data = @project.songs.map{ |song| { name: song.name, url: song.file_url } }
      render :json => data, status: :created
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # PUT api/projects/:id/new_branch
  def new_branch
    @project = Project.find(params[:projId])
    @project.add_branch( params[:newBranchName], params[:sourceBranchName] )
    render :json => @project
  end

  # PUT api/projects/:id/delete_branch
  def delete_branch
    @project = Project.find(params[:projId])
    @project.delete_branch(params[:branchName])
    render :json => @project
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
      @branch.delete_song(@song)
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
    @branch.delete_song(@oldSong)

    #add new song to project and branch
    @project.add_songs(params[:files], params[:branchName])

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
  # PUT api/projects/:id/invite_user
  def invite_user
    @project = Project.find(params[:projId])
    
    #todo - send an email to the new user, inviting them to join
    UserMailer.with(newUserEmail: params[:newUserEmail]).share_project_email.deliver_now #! not sending in dev env

    #add new user to project
    # if params[:userId]
    #   @user = User.find(params[:userId])
    #   @project.add_shared_user(@user) #!
    # end
  end

  private

end

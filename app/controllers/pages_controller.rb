=begin

DATA FETCHING
get project
get commit
post project
post commit --> put project
put commit 
delete proj
delete commit

=end

class PagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!, only: [:home]

  def home
    @user = current_user
  end

  # get the project
  def shared_project
    @project = Project.find(params[:id])

    # respond_to do |format|
    #   format.html
    #   format.json { render :json => @project }
    # end

    render :json => @project
  end

  def learn
    # respond_to do |format|
    #   format.html
    #   format.json { render :json => {page: 'learn'} }
    # end
    render :json => {page: 'learn'}
  end
end

class SongController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false
  
  # GET 'api/songs/:id'
  def get
    @song = Song.find(params['id'])
    render :json => {:song => @song}
    # todo - render :json => @song
  end

  def post
  end

  # POST 'api/songs/:id/update'
  def update
  end
end

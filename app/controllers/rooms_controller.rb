class RoomsController < ApplicationController

  def index
    @rooms = Room.where(:public => true).order("created_at DESC").limit(10)
    @new_room = Room.new
  end

  def create
    config_opentok
    session = @opentok.create_session request.remote_addr
    params[:room][:sessionId] = session.session_id

    @new_room = Room.new(params[:room])

    respond_to do |format|
      if @new_room.save
        format.html { redirect_to("/party/"+@new_room.id.to_s) }
      else
        format.html { render :controller => 'rooms', :action => "index" }
      end
    end
  end

  def party
    @room = Room.find(params[:id])

    config_opentok

    @tok_token = @opentok.generate_token :session_id => @room.sessionId
  end

  def record
    @room = Room.first
    config_opentok
    @tok_token = @opentok.generate_token :session_id => @room.sessionId
  end

  def sizing
    @room = Room.first
    config_opentok
    @tok_token = @opentok.generate_token :session_id => @room.sessionId
  end

  private

  def config_opentok
    if @opentok.nil?
      @opentok = OpenTok::OpenTokSDK.new '22262222', "504037a81d8fc4d2263404db1e852498f34a7ce3"
    end
  end
end
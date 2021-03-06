class NotesController < ApplicationController
  include ActionController::Live
  before_action :set_note, only: [:show, :edit, :update, :destroy]
  before_action :set_board, only: [:events]
  
  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.all
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  # POST /notes.json
  def create
    @note = Note.new(note_params)

    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: 'Note was successfully created.' }
        format.json { render :show, status: :created, location: @note }
        $redis.publish('notes.create', @note.to_json)
      else
        format.html { render :new }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @note, notice: 'Note was successfully updated.' }
        format.json { render :show, status: :ok, location: @note }    
        $redis.publish('notes.update', @note.to_json)
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to notes_url, notice: 'Note was successfully destroyed.' }
      format.json { head :no_content }
      $redis.publish('notes.delete', @note.to_json)
    end
  end
  
  def events
    response.headers["Content-Type"]="text/event-stream"
    redis = Redis.new
    redis.psubscribe('notes.*') do |on|
      on.pmessage do |pattern, event, data|
        parsed_data = JSON.parse data
        if parsed_data['board_id'] == @board.id
          response.stream.write "event: #{event}\n"
          response.stream.write "data:{\"note\": #{data}}\n\n"
        end
      end
    end
  rescue IOError  
    logger.info "Stream Closed"
  ensure
    redis.quit
    response.stream.close
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end
    
    def set_board
      @board = Board.find(params[:board_id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.require(:note).permit(:board_id, :text, :x, :y, :color)
    end
end

class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
    #figure out how to find a featured event and what it is
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
    @admin = User.find(@event.admin_id)
    @nb_guests = Attendance.where(event_id: @event.id).count
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(title: params[:title], 
      description: params[:description],
      location: params[:location],
      price: params[:price],
      start_date: params[:start_date],
      duration: params[:duration],
      admin_id: current_user.id)
    
    puts "-*-*"*500
    puts params[:avatar].class
    if @event.save # essaie de sauvegarder en base @gossip
      if params[:avatar]
        @event.avatar.attach(params[:avatar])
      else
        downloaded_image = open(Faker::LoremPixel.image(secure: false))
        @event.avatar.attach(io: downloaded_image  , filename: "faker.jpg")
      end
        flash[:success] = "You successfuly created an event"
        redirect_to :controller => 'events', :action => 'show', id: @event.id
    else
      # This line overrides the default rendering behavior, which
      # would have been to render the "create" view.
      flash.now[:danger] = "Error with the account creation"
      render :action => 'new'
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(title: params[:title], 
      description: params[:description],
      location: params[:location],
      price: params[:price],
      start_date: params[:start_date],
      duration: params[:duration],
      admin_id: current_user.id)
        @event.avatar.attach(params[:avatar])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.fetch(:event, {})
    end
end

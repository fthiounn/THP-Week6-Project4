class AttendancesController < ApplicationController
  before_action :set_attendance, only: [:show, :edit, :update, :destroy]
  # GET /attendances
  # GET /attendances.json
  def index
    @guests = User.joins(:attendances).where('attendances.event_id = ?', params[:event_id])
    puts @guests
    @event = Event.find(params[:event_id])
    @admin = User.find(@event.admin_id)
  end

  # GET /attendances/1
  # GET /attendances/1.json
  def show
  end

  # GET /attendances/new
  def new
    create
  end

  # GET /attendances/1/edit
  def edit
  end
  # POST /attendances
  # POST /attendances.json
  def create
    @attendance = Attendance.new(user: current_user, stripe_customer_id: params[:token], event: Event.find(params[:event]))

    if @attendance.save
      flash[:success] = "You successfuly attended an event"
      redirect_to :controller => 'users', :action => 'show', id: current_user.id
    else
      # This line overrides the default rendering behavior, which
      # would have been to render the "create" view.
      flash.now[:danger] = "Error attemprint to attend an event"
      render :action => 'new'
    end
  end

  # PATCH/PUT /attendances/1
  # PATCH/PUT /attendances/1.json
  def update
    respond_to do |format|
      if @attendance.update(attendance_params)
        format.html { redirect_to @attendance, notice: 'Attendance was successfully updated.' }
        format.json { render :show, status: :ok, location: @attendance }
      else
        format.html { render :edit }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attendances/1
  # DELETE /attendances/1.json
  def destroy
    @attendance.destroy
    respond_to do |format|
      format.html { redirect_to attendances_url, notice: 'Attendance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendance
      @attendance = Attendance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attendance_params
      params.fetch(:attendance, {})
    end
end

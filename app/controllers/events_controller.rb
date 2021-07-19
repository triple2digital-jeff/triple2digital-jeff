class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:register, :preview]

  before_action :set_event, only: [:show, :edit, :update, :destroy, :register, :preview]
  layout 'home', except: [:register, :preview]
  # GET /events
  # GET /events.json
  def index
    if params[:user_id]
      @user = User.find_by_id(params[:user_id])
      @events = Event.where(owner_id: params[:user_id]).page(params[:page])
    else
      @events = Event.where(search_condition).page(params[:page])
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new_admin
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to events_path, notice: 'Event was successfully updated.' }
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


  def register

  end

  def preview
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id] || params[:event_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:id, :description, :end_date, :is_paid, :price, :start_date, :status, :title, :owner_id)
  end

  def search_condition
    query = ''
    query += "start_date = '#{params[:start_date]}'" if params[:start_date].present?
    query += "AND end_date = '#{params[:end_date]}'" if params[:end_date].present?
    query += 'AND price >= '+params[:min_price] if params[:min_price].present?
    query += 'AND price <= '+params[:max_price] if params[:max_price].present?
    query
  end
end

class Api::V1::SavedEventsController < ApplicationController

  # skip_before_action :verify_authenticity_token

  before_action :verify_api_token#, except: [:create]
  before_action :find_user, only: [:index, :services]
  # before_action :set_event, only: [:show, :update, :destroy]

  # GET /events
  def index
    @saved_events = @user.my_saved_events
    render json: @saved_events, user_id: @user
  end

  def services
    saved_services = @user.my_saved_services
    render json: saved_services, user_id: @user
  end
  #
  # # GET /events/1
  # def show
  #   render json: @event, include: [:ticket_packages]
  # end

  # POST /events
  def create
    @event = SavedEvent.where(saved_event_params).first_or_initialize
    if @event.save
      render json: {:success => "#{params[:saved_event][:saveable_type]} has been saved successfully."}
    else
      render :json => {:error => "Unable to save #{params[:saved_event][:saveable_type]} at this time.", error_log: @event.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  def unsave
    events = SavedEvent.where(user_id: params[:saved_event][:user_id], saveable_id: params[:saved_event][:saveable_id], saveable_type: params[:saved_event][:saveable_type])
    if events.present? && events.destroy_all
      render json: {:success => "#{params[:saved_event][:saveable_type]} has been unsaved successfully."}
    else
      render json: { errors: "No saved #{params[:saved_event][:saveable_type]} exists with provided details" }, status: 401
    end
  end


  def saved_event_params
    params.require(:saved_event).permit(:user_id, :saveable_id, :saveable_type)
  end

  private

  def verify_api_token
    return true if authenticate_token
    render json: { errors: "Access denied" }, status: 401
  end

  def authenticate_token
    return false if params[:api_token].blank?
    User.find_by(api_token: params[:api_token])
  end

  def find_user
    begin
      @user = User.find(params[:user_id])
    rescue
      render :json => {:error => "User not found with provided id"}, :status => 404
    end
  end
end
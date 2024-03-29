class Api::V1::EndorsementsController < ApplicationController

  # skip_before_action :verify_authenticity_token

  before_action :verify_api_token
  before_action :set_endorsement, only: [:show, :update, :destroy]

  # GET /endorsements
  def index
    @endorsements = Endorsement.all
    render json: @endorsements, include: [:endorsed_by, :endorsed_to]
  end

  # GET /endorsements/1
  def show
    render json: @endorsement, include: [:endorsed_by, :endorsed_to]
  end

  # Endorsement /endorsements
  def create
    @endorsement = Endorsement.new(endorsement_params)
    if @endorsement.save
      nuser = @endorsement.endorsed_to
      if nuser.is_endrose
        token = nuser.user_devices.active.pluck(:push_token)
        FcmPush.new.send_push_notification('',"Endorse by #{@endorsement.endorsed_by.first_name}",token) if token.present?
        nuser.notifications.create(notification_type: 'endorsement', description: "Endorsed by #{@endorsement.endorsed_by.first_name}", notifier_id:@endorsement.endorsed_by.try(:id), object_id: @endorsement.id)
      end
      render json: @endorsement, include: [:endorsed_by, :endorsed_to], status: :created
    else
      render :json => {:error => "Unable to create endorsement at this time.", error_log: @endorsement.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  # PATCH/PUT /endorsements/1
  def update
    if @endorsement.update(endorsement_params)
      render json: @endorsement, include: [:endorsed_by, :endorsed_to]
    else
      render :json => {:error => "Unable to update record this time. Please try again later.", error_log: @endorsement.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  def un_endorse
    begin
      @endorsement = Endorsement.where(endorsed_to_id: params[:endorsed_to_id], endorsed_by_id: params[:endorsed_by_id]).first
      endorsement = @endorsement
      @endorsement.destroy
      nuser = endorsement.endorsed_to
      #if nuser.is_endrose
        #token = nuser.user_devices.active.pluck(:push_token)
        #FcmPush.new.send_push_notification('',"You have been removed endorsed by #{endorsement.endorsed_by.first_name}",token) if token.present?
        #nuser.notifications.create(notification_type: 'unendorsement', description: "You have been removed endorsed by #{endorsement.endorsed_by.first_name}", notifier_id: endorsement.endorsed_by.try(:id), object_id: endorsement.id)
      #end
      render :json => {:success => "Un endorsed successfully"}, :status => :ok
    rescue
      render :json => {:error => "Unable to un endorse this time. Please try again later."}, :status => :unprocessable_entity
    end
  end

  # DELETE /endorsements/1
  def destroy
    if @endorsement.destroy
      render :json => {:success => "Endorsement deleted successfully"}, :status => :ok
    else
      render :json => {:error => "Unable to delete endorsement at this time.", error_log: @endorsement.errors.full_messages}, :status => :unprocessable_entity
    end

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_endorsement
    begin
      @endorsement = Endorsement.find(params[:id])
    rescue
      render :json => {:error => "Endorsement not found with provided id"}, :status => 404
    end
  end


  # Only allow a trusted parameter “white list” through.
  def endorsement_params
    params.require(:endorsement).permit(:endorsed_to_id, :endorsed_by_id)
  end

  def verify_api_token
    return true if authenticate_token
    render json: { errors: "Access denied" }, status: 401
  end

  def authenticate_token
    return false if params[:api_token].blank?
    User.find_by(api_token: params[:api_token])
  end


end
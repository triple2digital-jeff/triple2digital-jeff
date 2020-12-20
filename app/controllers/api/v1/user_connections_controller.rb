class Api::V1::UserConnectionsController < ApplicationController

  # skip_before_action :verify_authenticity_token

  before_action :verify_api_token
  before_action :set_user_connection, only: [:show, :update, :destroy]
  before_action :set_user, only: [:get_connection_requests, :get_all_my_approved_connection_list, :get_connection_requests_new]

  # GET /user_connections
  def index
    @user_connections = UserConnection.all
    render json: @user_connections
  end

  # all connection requests sent to user
  def get_connection_requests
    render json: @user.inverse_user_connections, include: [:user]
  end

  def get_connection_requests_new
    render json: @user.inverse_user_connections+@user.user_connections, include: [:user, :connection]
  end

  def get_all_my_approved_connection_list
    render json: @user.inverse_connections.approved+@user.connections.approved
  end

  # GET /user_connections/1
  def show
    render json: @user_connection
  end

  # UserConnection /user_connections
  def create
    @user_connection = UserConnection.new(user_connection_params)
    if @user_connection.save
      render json: @user_connection, status: :created
    else
      render :json => {:error => "Unable to create connection at this time.", error_log: @user_connection.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  # PATCH/PUT /user_connections/1
  def update
    if @user_connection.update(user_connection_params)
      render json: @user_connection
    else
      render :json => {:error => "Unable to update record this time. Please try again later.", error_log: @user_connection.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  # DELETE /user_connections/1
  def destroy
    if @user_connection.destroy
      render :json => {:success => "Connection request deleted successfully"}, :status => :ok
    else
      render :json => {:error => "Unable to delete connection at this time.", error_log: @user_connection.errors.full_messages}, :status => :unprocessable_entity
    end

  end

  def remove_connection
    begin
      UserConnection.where("user_id IN(?) AND connection_id IN(?)",[params[:user_id],params[:connection_id]], [params[:user_id],params[:connection_id]]).first.destroy
      render :json => {:success => "Removed connection successfully"}, :status => :ok
    rescue
      render :json => {:error => "Unable to remove connection at this time Please try again later."}, :status => :unprocessable_entity
    end
  end

  def connection_requests
    begin
      @user = User.find(params[:user_id])
      render json: @user.inverse_user_connections.requested_connections, include: [:user]
    rescue
      render :json => {:error => "No connections found with provided details"}, :status => :not_found
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user_connection
    begin
      @user_connection = UserConnection.find(params[:id])
    rescue
      render :json => {:error => "Connection not found with provided id"}, :status => :not_found
    end
  end

  def set_user
    begin
      @user = User.find(params[:user_id])
    rescue
      render :json => {:error => "User not found with provided id"}, :status => :not_found
    end
  end

  # Only allow a trusted parameter “white list” through.
  def user_connection_params
    params.require(:user_connection).permit(:user_id, :connection_id, :status)
  end

  def verify_api_token
    return true if authenticate_token
    render json: { errors: "Access denied" }, status: :unauthorized
  end

  def authenticate_token
    return false if params[:api_token].blank?
    User.find_by(api_token: params[:api_token])
  end


end
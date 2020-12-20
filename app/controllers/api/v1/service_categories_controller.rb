class Api::V1::ServiceCategoriesController < ApplicationController
  # before_action :authenticate_user!

  # skip_before_action :verify_authenticity_token

  before_action :verify_api_token
  before_action :set_service_category, only: [:show, :update, :destroy]

  # GET /service_categories
  def index
    @service_categories = ServiceCategory.all
    render json: @service_categories
  end

  # GET /service_categories/1
  def show
    render json: @service_category
  end

  # ServiceCategory /service_categories
  def create
    @service_category = ServiceCategory.new(endorsement_params)
    if @service_category.save
      render json: @service_category, status: :created
    else
      render :json => {:error => "Unable to create service_category at this time.", error_log: @service_category.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  # PATCH/PUT /service_categories/1
  def update
    if @service_category.update(endorsement_params)
      render json: @service_category
    else
      render :json => {:error => "Unable to update record this time. Please try again later.", error_log: @service_category.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  # DELETE /service_categories/1
  def destroy
    if @service_category.destroy
      render :json => {:success => "ServiceCategory deleted successfully"}, :status => :ok
    else
      render :json => {:error => "Unable to delete service_category at this time.", error_log: @service_category.errors.full_messages}, :status => :unprocessable_entity
    end

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_service_category
    begin
      @service_category = ServiceCategory.find(params[:id])
    rescue
      render :json => {:error => "ServiceCategory not found with provided id"}, :status => 404
    end
  end


  # Only allow a trusted parameter “white list” through.
  def service_category_params
    params.require(:service_category).permit(:title, :description)
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

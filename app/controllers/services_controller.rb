class ServicesController < ApplicationController
  before_action :authenticate_user!, except: [:preview]


  before_action :set_service, only: [:show, :edit, :update, :destroy, :preview]
  layout 'home', except: [:preview]
  # GET /services
  # GET /services.json
  def index
    # byebug
    options = {
        # keyword: params[:keyword],
        latitude: params[:latitude],
        longitude: params[:longitude],
        distance: params[:distance],
        category: params[:category],
        min_price: params[:min_price],
        max_price: params[:max_price],
        user_id: params[:user_id]
    }
    @services = Service.search(options).page(params[:page])
    # if params[:user_id]
    #   @services = Service.where(owner_id: params[:user_id]).page(params[:page])
    # else
    #   @services = Service.all.page(params[:page])
    # end
  end

  # GET /services/1
  # GET /services/1.json
  def show
  end

  # GET /services/new_admin
  def new
    @service = Service.new
  end

  # GET /services/1/edit
  def edit
  end

  def preview
  end

  # POST /services
  # POST /services.json
  def create
    @service = Service.new(service_params)

    respond_to do |format|
      if @service.save
        format.html { redirect_to @service, notice: 'Service was successfully created.' }
        format.json { render :show, status: :created, location: @service }
      else
        format.html { render :new }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /services/1
  # PATCH/PUT /services/1.json
  def update
    respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to services_path, notice: 'Service was successfully updated.' }
        format.json { render :show, status: :ok, location: @service }
      else
        format.html { render :edit }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    @service.destroy
    respond_to do |format|
      format.html { redirect_to services_url, notice: 'Service was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_service
    @service = Service.find(params[:id] || params[:service_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def service_params
    params.require(:service).permit(:title, :note, :price, :duration, :time_type, :owner_id, :is_private)
  end

end

class PaymentsController < ApplicationController

  before_action :authenticate_user!, except: [:register]

  before_action :set_payment, only: [:show, :edit, :update, :destroy, :register]
  layout 'home', except: [:register]
  # GET /payments
  # GET /payments.json
  def index
    options = {
        # keyword: params[:keyword],
        user: params[:user]
    }
    @payments = Payment.search(options).page(params[:page])
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
  end

  # GET /payments/new_admin
  def new
    @payment = Payment.new
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(payment_params)

    respond_to do |format|
      if @payment.save
        format.html { redirect_to @payment, notice: 'Payment was successfully created.' }
        format.json { render :show, status: :created, location: @payment }
      else
        format.html { render :new }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to payments_path, notice: 'Payment was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment }
      else
        format.html { render :edit }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_url, notice: 'Payment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def register

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_payment
    @payment = Payment.find(params[:id] || params[:payment_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def payment_params
    params.require(:payment).permit(:id, :user_id, :amount, :created_at, :status)
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

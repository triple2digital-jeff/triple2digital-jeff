class ChargesController < ApplicationController

  before_action :authenticate_user!, except: [:register, :validate_tickets_count, :charge_new_user_for_event, :registration]

  before_action :set_charge, only: [:show, :edit, :update, :destroy, :register]
  layout 'home', except: [:register]
  # GET /charges
  # GET /charges.json
  def index
    options = {
        # keyword: params[:keyword],
        user: params[:user],
        owner: params[:owner],
        event: params[:event],
        date_from: params[:from_date],
        date_to: params[:to_date]
    }
    @charges = Charge.search(options).page(params[:page])
  end

  # GET /charges/1
  # GET /charges/1.json
  def show
  end

  # GET /charges/new_admin
  def new
    @charge = Charge.new
  end

  # GET /charges/1/edit
  def edit
  end

  # POST /charges
  # POST /charges.json
  def create
    @charge = Charge.new(charge_params)

    respond_to do |format|
      if @charge.save
        format.html { redirect_to @charge, notice: 'Charge was successfully created.' }
        format.json { render :show, status: :created, location: @charge }
      else
        format.html { render :new }
        format.json { render json: @charge.errors, status: :unprocessable_entity }
      end
    end
  end

  def charge_new_user_for_event
    user, new_user = create_temp_user(params)
    if user.try(:id).present?
      event = Event.find(params[:event_id])
      user.update_columns(confirmed_at: nil, confirmation_token: SecureRandom.base64.tr('+/=', 'Qrt')) if new_user
      registration = Event.register_for_event(JSON.parse(params[:ticket_attributes][0]), user.id, event)
    end
    success = (user.try(:id).present? && registration[0].present?) ? true : false
    message = user.errors.present? ? user.errors.messages : nil
    if user.try(:id).present? && registration[0].present? && params[:amount].to_i > 0
      StripeCustomer.create_customer(params[:email], params[:stripeToken], user) if user.present?
      pars = params[:ticket_packages].map {|obj| YAML.load(obj)}
      new_params, event_params = {}, {}
      new_params['ticket_packages'] = pars[0]
      event_params['event'] = new_params
      response = StripeCustomer.new(user, params[:amount], event, event_params).web_charge
      unless response
      # remove all registered tickets
       registration[3].update_all(:owner_id=>nil)
       message = "Something went wrong with your payment, try again later."
       success = false
      end
    end

    if success
      EventMailer.event_registration(user, registration[0], registration[1], event, registration[2], registration[3], new_user).deliver
      # format.html { render :charge_new_user_for_event }
      respond_to do |format|
        format.html { redirect_to "/registration", notice: "Congrats: You have Successfully bought #{registration[0]} #{'ticket'.pluralize(registration[0])}" }
        format.json {render json: {message: "You have successfully bought #{registration[0]} #{'ticket'.pluralize(registration[0])}"}, status: :ok}
      end
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, alert: message || "Something went wrong, try again later" }
        format.json { render :json => {:message => message || "Something went wrong, try again later"}, :status => :unprocessable_entity }
      end

    end

  end


  def validate_tickets_count
    event = Event.find(params[:event_id])
    unless validate_data
      render json: {error: @json}, status: :unprocessable_entity and return unless validate_data
    else
      render json: {is_free_event: event.is_free_event?, is_tax_by_creator: event.is_tax_by_creator}
    end
  end


  def create_temp_user(params)
    email = params[:email].present? ? params[:email].downcase : params[:stripeEmail].downcase
    first_name = params[:first_name].present? ? params[:first_name] : "Anonymous"
    last_name = params[:last_name].present? ? params[:last_name] : "User"
    user = User.find_by(email: email)
    new_user = false
    unless user.present?
      user = User.new(first_name: first_name, last_name: last_name, email: email, phone: params[:phone])
      user.password = user.password_confirmation = "pr3uis84"
      user.skip_confirmation!
      user.save
      new_user = SecureRandom.base64.tr('+/=', 'Qrt')[0,7]
    end
    return user, new_user
  end

  # PATCH/PUT /charges/1
  # PATCH/PUT /charges/1.json
  def update
    respond_to do |format|
      if @charge.update(charge_params)
        format.html { redirect_to charges_path, notice: 'Charge was successfully updated.' }
        format.json { render :show, status: :ok, location: @charge }
      else
        format.html { render :edit }
        format.json { render json: @charge.errors, status: :unprocessable_entity }
      end
    end
  end

  def registration
    render layout: false
  end

  # DELETE /charges/1
  # DELETE /charges/1.json
  def destroy
    @charge.destroy
    respond_to do |format|
      format.html { redirect_to charges_url, notice: 'Charge was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def register

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_charge
    @charge = Charge.find(params[:id] || params[:charge_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def charge_params
    params.require(:charge).permit(:id, :description, :end_date, :is_paid, :price, :start_date, :status, :title, :owner_id)
  end

  def search_condition
    query = ''
    query += "start_date = '#{params[:start_date]}'" if params[:start_date].present?
    query += "AND end_date = '#{params[:end_date]}'" if params[:end_date].present?
    query += 'AND price >= '+params[:min_price] if params[:min_price].present?
    query += 'AND price <= '+params[:max_price] if params[:max_price].present?
    query
  end

  def validate_data
    @json = ''
    JSON.parse(params[:ticket_attributes]).each do |attributes|
      ticket_package = TicketPackage.find_by(id: attributes["ticket_package_id"])
      available = ticket_package.available_tickets.eql?(0) ?  "No ticket" : "There are Only #{ticket_package.available_tickets} tickets"
      @json = available+" left for #{ticket_package.ticket_type} package." and return false if ticket_package.available_tickets < attributes["count"].to_i
    end
    true
  end

end

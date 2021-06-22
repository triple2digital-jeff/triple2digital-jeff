class Api::V1::TicketsController < ApplicationController

  # skip_before_action :verify_authenticity_token

  before_action :verify_api_token
  before_action :set_ticket, only: [:update]

  def index
    user = User.find_by(id: params[:user_id])
    render json: "No user exists with id - #{params[:id]}", status: :unprocessable_entity and return if user.nil?
    events = user.get_events_by_user_tickets
    render json: events, include: {ticket_packages: {}, current_user_id: user.id}
  end

  def show
    ticket = Ticket.find_by(id: params[:id])
    render json: "No ticket exists with id - #{params[:id]}", status: :unprocessable_entity and return if ticket.nil?
    render json: ticket, include: [:event, :ticket_package]
  end

  # TO DO: Check if the tickets are still available against package.
  def create
    if(ticket_params[:ticket_attributes].present?)
      render json: {error: @json}, status: :unprocessable_entity and return unless validate_data
      registration = Event.register_for_event(ticket_params[:ticket_attributes], ticket_params[:buyer_id], @event)
      if (params[:refer_code].present? && !@event.refers_id.include? params[:refer_code])
        user = User.find_by(refer_code: params[:refer_code])
        if user.is_skilled
          @event.update(refers_id: @event.refers_id.push(params[:refer_code]))
          VoucherApiService.new().create_voucher(user, 'PROFILER')
        end
      end
      EventMailer.event_registration(@user, registration[0], registration[1], @event, registration[2], registration[3], false).deliver
      nuser = @event.owner
      if nuser.is_tickets_sold
        token = nuser.user_devices.active.pluck(:push_token)
        FcmPush.new.send_push_notification('',"#{@user.first_name} Purchased an event ticket",token) if token.present?
        nuser.notifications.create(notification_type: 'purchased_ticket', description: "#{@user.first_name} Purchased an event ticket", notifier_id: @user.try(:id), object_id: @event.id)
      end
      render json: {message: "Successfully bought #{registration[0]} #{'ticket'.pluralize(registration[0])}"}, status: :ok
    else
      render json: {error: 'Unable to create event at this time.', error_log: 'Please provide ticket attributes to process.'}, status: :unprocessable_entity
    end
  end

  def update
    @msg=nil
    @msg= "Ticket has been scanned already" if @ticket.has_scanned
    if params[:has_scanned].present? && !@ticket.has_scanned && @ticket.update(has_scanned: params[:has_scanned])
      render json: @ticket
    else
      render :json => {:error => @msg || "Unable to update record this time. Please try again later.", error_log: @ticket.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  private

  def set_ticket
    begin
      @ticket = Ticket.find(params[:id])
    rescue
      render :json => {:error => "Ticket not found with provided id"}, :status => 404
    end
  end

  def ticket_params
    params.require(:event).permit(:id, :buyer_id, ticket_attributes: [:ticket_package_id, :count])
  end

  def verify_api_token
    return true if authenticate_token
    render json: { errors: "Access denied" }, status: 401
  end

  def authenticate_token
    return false if params[:api_token].blank?
    User.find_by(api_token: params[:api_token])
  end

  def validate_data
    @json = ''
    @user = User.find_by(id: ticket_params[:buyer_id])
    @event = Event.find_by(id: ticket_params[:id])

    @json = "No buyer exists with id - #{ticket_params[:buyer_id]}" and return false if @user.nil?
    @json = "No event exists with id - #{ticket_params[:id]}" and return false if @event.nil?
    ticket_params[:ticket_attributes].each do |attributes|
      # byebug
      ticket_package = TicketPackage.find_by(id: attributes[:ticket_package_id])
      @json = 'Ticket Package Not Found.' and return false if ticket_package.nil?
      @json = 'The provided package dose not belongs to this event' and return false if ticket_package.event_id != @event.id
      @json = "Only #{ticket_package.available_tickets} left for #{ticket_package.ticket_type} type." and return false if ticket_package.available_tickets < attributes[:count].to_i
    end
    true
  end
end
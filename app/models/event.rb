# == Schema Information
#
# Table name: events
#
#  id                :bigint           not null, primary key
#  address           :string
#  cover_image       :text             default("http://app.profilerlife.com/images/default_cover.png")
#  description       :text
#  dress_code        :string
#  end_date          :datetime
#  has_published     :boolean          default(FALSE)
#  is_enabled        :integer          default(0)
#  is_free_event     :boolean          default(FALSE)
#  is_paid           :boolean          default(FALSE)
#  is_recurring      :boolean          default(FALSE)
#  is_tax_by_creator :boolean          default(FALSE)
#  latitude          :float
#  longitude         :float
#  max_tickets       :integer          default(0)
#  price             :float            default(0.0)
#  recurring_type    :integer          default(0)
#  speaker           :string
#  start_date        :datetime
#  status            :string
#  title             :string
#  video_url         :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  owner_id          :integer
#  refers_id         :text             default([]), is an Array
#

class Event < ApplicationRecord

  ############ Associations ##############
  belongs_to :owner, class_name: 'User'
  has_many :ticket_packages, dependent: :destroy
  has_many :tickets
  has_many :charges
  has_many :payments
  has_many :outgoing_payments, dependent: :destroy

  include Reviewable

  has_many :saved_events, as: :saveable, dependent: :destroy


  ############ Scopes ##############
  scope :un_published, -> { where('has_published IS FALSE') }
  scope :published, -> { where('has_published IS TRUE') }
  scope :upcoming, -> { where('start_date >= ?', DateTime.now) }
  scope :completed, -> { where('end_date <= ?', DateTime.now) }

  ############ Validations ##############

  validates :title, :description, :start_date, :end_date, :latitude, :longitude, :address, presence: true

  accepts_nested_attributes_for :ticket_packages
  reverse_geocoded_by :latitude, :longitude

  #GB: Fields to be displayed in filter dropdown on listing page
  def self.filter_fields
    {
        title: 'Title',
        status: 'Status'
    }
  end

  def attributes
    {
        id: self.id,
        start_date: self.start_date,
        end_date: self.end_date,
        title: self.title,
        description: self.description,
        status: self.status,
        price: self.price,
        is_paid: self.is_paid?,
        'created_at' => self.created_at,
        updated_at: self.updated_at,
        latitude: self.latitude,
        longitude: self.longitude,
        address: self.address,
        dress_code: self.dress_code,
        speaker: self.speaker,
        cover_image: self.cover_image,
        video_url: self.video_url,
        has_published: self.has_published?,
        max_tickets: self.max_tickets,
        is_recurring: self.is_recurring,
        recurring_type: self.recurring_type,
        is_enabled: self.is_enabled,
        total_tickets: self.total_tickets,
        is_tax_by_creator: self.is_tax_by_creator,
        available_tickets: self.available_tickets,
        owner: owner
    }

  end

  def available_tickets
    self.tickets.available.count
  end

  def total_tickets
    self.tickets.count
  end

  def self.search(options = {})
    events = Event.all
    events = events.near([options[:latitude].to_f, options[:longitude].to_f], options[:distance] || 5, units: :km) if options[:latitude].present? && options[:longitude].present?
    events = events.where("price >= ?", options[:min_price]) if options[:min_price].present?
    events = events.where("price <= ?", options[:max_price]) if options[:max_price].present?

    events = events.where("start_date >= ?", options[:from_date]) if options[:from_date].present?
    events = events.where("start_date <= ?", options[:to_date]) if options[:to_date].present?
    events = events.where("title ILIKE ?", "%#{options[:title]}%").distinct if options[:title].present?

    events
  end

  def reviews_count
    reviews.count
  end
  def average_rating
    reviews.average(:rating).to_f.round(2)
  end

  def reviews_respnded
    reviews.reponded
  end

  def has_occured
    reviews.occured
  end

  def has_not_occured
    reviews.not_occured
  end

  def has_occured_percent
    reviews_respnded.count == 0 ? 0 : (has_occured.count.to_f/reviews_respnded.count)*100
  end

  def has_not_occured_percent
    reviews_respnded.count == 0 ? 0 : (has_not_occured.count.to_f/reviews_respnded.count)*100
  end

  def not_responded
    reviews.later_on
  end

  def not_responded_percent
    reviews_count == 0 ? 0 : (not_responded.count.to_f/reviews_count)*100
  end


  def self.register_for_event(ticket_params, buyer_id, event)
    begin
      total_tickets = 0
      total_price = 0.0
      purchased_tickets = []
      ticket_packgs =[]
      buyer = User.find_by_id(buyer_id)
      ticket_params.each do |attributes|
        ticket_package = TicketPackage.find_by(id: attributes["ticket_package_id"])
        ticket_package.tickets.available.limit(attributes["count"].to_i).update_all(owner_id: buyer_id)
        total_tickets += attributes["count"].to_i
        price = ticket_package.price*attributes["count"].to_i
        total_price += price
        ticket_packgs.push(ticket_package.id)
        purchased_tickets.push({title: ticket_package.ticket_type, count: attributes["count"].to_i, price: price})
      end
      tickets = buyer.tickets.where("ticket_package_id IN(?)", ticket_packgs)
      # EventMailer.event_registration(buyer, total_tickets, purchased_tickets, event, total_price, tickets).deliver
      return total_tickets, purchased_tickets, total_price, tickets
    rescue
      return nil, nil, nil, nil
    end
  end


  # def upcoming
  #   start_date.present?
  # end
  #
  # def un_published
  #   !has_published?
  # end
  #
  # def history
  #   title.present?
  # end

  def as_json(options = {})
    json_to_return = super
    # byebug

    json_to_return[:average_rating] = average_rating
    json_to_return[:total_ratings] = reviews_count
    json_to_return[:is_saved] = has_saved_event(options[:user_id]) if options[:user_id].present?
    return json_to_return if !options[:include].present? || !options[:include].is_a?(Hash)
    json_to_return[:user_tickets] = user_tickets(options[:include][:current_user_id]) if options[:include].present? && options[:include][:current_user_id].present?

    return json_to_return
  end

  def has_saved_event(user)
    # return 'true'
    user.my_saved_events.include? self
  end

  def current_user_id
    return nil
  end

  def user_tickets(user_id)
    self.tickets.where(owner_id: user_id)
  end

  def fetch_attendees
    tickets.group_by(&:owner_id)
  end

  def user_attendees
    User.where("id IN(?)",tickets.pluck(:owner_id).uniq)
  end

end

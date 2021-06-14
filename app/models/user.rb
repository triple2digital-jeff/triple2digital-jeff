# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  address                :string
#  age                    :string
#  api_token              :string
#  city                   :string
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  country                :string
#  cover_img              :string           default("http://app.profilerlife.com/images/default_cover.png")
#  dob                    :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  gender                 :string
#  is_book_service        :boolean          default(TRUE), not null
#  is_cancel_appointment  :boolean          default(TRUE), not null
#  is_comments            :boolean          default(TRUE), not null
#  is_endrose             :boolean          default(TRUE), not null
#  is_event_details       :boolean          default(TRUE), not null
#  is_likes               :boolean          default(TRUE), not null
#  is_service_notes       :boolean          default(TRUE), not null
#  is_shares              :boolean          default(TRUE), not null
#  is_skilled             :boolean          default(FALSE)
#  is_tickets_sold        :boolean          default(TRUE), not null
#  is_upcoming_events     :boolean          default(TRUE), not null
#  last_name              :string
#  latitude               :float
#  longitude              :float
#  phone                  :string
#  profile_img            :string           default("http://app.profilerlife.com/images/user.png")
#  provider               :string
#  refer_code             :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :string
#  state                  :string
#  stripe_payout_token    :string
#  stripe_token           :string
#  uid                    :string
#  unconfirmed_email      :string
#  zipcode                :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  skill_id               :integer
#  sub_skill_id           :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  ############ Associations ##############
  has_one_attached :avatar
  has_many :user_devices, dependent: :destroy
  #has_many :push_logs, dependent: :destroy
  # has_and_belongs_to_many :custom_pushes
  # has_and_belongs_to_many :categories
  has_and_belongs_to_many :categories
  has_many :posts, dependent: :destroy
  has_many :comments, through: :posts
  has_many :post_likes, :foreign_key => 'liked_by_id'
  belongs_to :skill, optional: true
  belongs_to :sub_skill, optional: true
  has_many :appointments, dependent: :destroy
  has_many :working_days, dependent: :destroy
  has_many :services, through: :appointments
  has_many :owned_services, :foreign_key => 'owner_id', class_name: 'Service', dependent: :destroy
  has_many :owned_events, :foreign_key => 'owner_id', class_name: 'Event'
  has_many :endorsements, :foreign_key => 'endorsed_to_id', class_name: 'Endorsement', dependent: :destroy
  has_many :endorsed, :foreign_key => 'endorsed_by_id', class_name: 'Endorsement', dependent: :destroy
  has_many :report_posts, dependent: :destroy
  has_many :visits, dependent: :destroy
  has_many :visitors, through: :visits

  has_many :user_connections
  has_many :notifications, dependent: :destroy

  has_many :connections, through: :user_connections do
    def approved
      where("user_connections.status = ?", 1)
    end
  end

  has_many :inverse_user_connections, :class_name => "UserConnection", :foreign_key => "connection_id"
  has_many :inverse_connections, :through => :inverse_user_connections, :source => :user do
    def approved
      where("user_connections.status = ?", 1)
    end
  end
  has_many :reviews, dependent: :destroy
  has_many :events, foreign_key: 'owner_id', dependent: :destroy
  has_many :tickets, foreign_key: 'owner_id', dependent: :destroy

  has_many :saved_events, dependent: :destroy #can be an event or service
  # has_many :groups, through: :memberships, source: :memberable, source_type: 'Group'

  has_many :received_charges, foreign_key: 'owner_id', class_name: "Charge"
  has_many :charges
  has_many :payments
  has_many :my_saved_events, through: :saved_events, source: :saveable, source_type:'Event', :foreign_key => 'owner_id', class_name: 'Event'
  has_many :my_saved_services, through: :saved_events, source: :saveable, source_type:'Service', :foreign_key => 'owner_id', class_name: 'Service'

  scope :attendies, -> { joins(:charges).uniq }
  scope :organizers, -> { joins(:events).uniq }
  scope :confirmed, -> { where("confirmed_at IS NOT NULL") }
  # scope :attendies, joins(:payments)
  has_many :outgoing_payments, dependent: :destroy


  has_many :sent_messages, foreign_key: 'sender_id', class_name: 'Message', dependent: :destroy
  has_many :received_messages, foreign_key: 'receiver_id', class_name: 'Message'
  has_many :sent_chats, foreign_key: 'sender_id', class_name: 'Chat', dependent: :destroy
  has_many :received_chats, foreign_key: 'receiver_id', class_name: 'Chat'

  ############ Attributes ##############
  reverse_geocoded_by :latitude, :longitude

  ############ Validations ##############

  validates :first_name, presence: true
  validates :email, presence: true, unless: -> { is_fb_user }
  validates :email, uniqueness:  true, unless: -> { is_fb_user }
  # validates :working_days, :length => { :maximum => 7 }

  validates :avatar, content_type: {in: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif'], message: 'Please upload a valid image'}
  validates :avatar, size: { less_than: 2.megabytes , message: 'Image size should be less than 2 MB' }
  after_save :create_default_working_days
  validate :validate_dummy_email
  #
  accepts_nested_attributes_for :working_days

  def validate_dummy_email
    errors.add(:email, 'Invalid or dummy emails are not allowed.') if email.include?("mailinator")
  end

  def my_user_connections
    my_all_connections.count
  end

  def my_all_connections
    self.connections.order("created_at DESC")+self.inverse_connections.order("created_at DESC")
  end

  def all_connections
    user_connections+inverse_user_connections
  end

  def verified_connections
    all_connections.select{|rec| rec.status==1}
  end

  def verified_with_user(user_id)
    verified_connections.select{|rec1| (rec1.user_id==user_id || rec1.connection_id==user_id)}
  end

  def req_connection_with_user(user_id)
    inverse_user_connections.where(user_id: user_id).first
  end

  def connection_posts
    Post.where("user_id IN(?)", verified_connections.pluck(:user_id, :connection_id).flatten)
  end

  def connection_events
    Event.where("owner_id IN(?)", verified_connections.pluck(:user_id, :connection_id).flatten).published
  end

  def endorsement_posts
    Post.where("user_id IN(?)", endorsed.pluck(:endorsed_to_id))
  end

  def endorsement_events
    Event.where("owner_id IN(?)", endorsed.pluck(:endorsed_to_id))
  end

  def upcoming(s_date, e_date)
    owned_events.published.where('start_date IS NOT NULL AND start_date > ?', s_date)
  end

  def un_published
    owned_events.un_published
  end

  def history(s_date, e_date)
    owned_events.published.where('end_date IS NOT NULL AND end_date < ?', e_date)
  end

  def user_events
    self.owned_events
  end

  def get_all_events(s_date=DateTime.now, e_date=DateTime.now)
    events={}
    events[:upcoming] = self.upcoming(s_date, e_date)
    events[:un_published] = self.un_published
    events[:history] = self.history(s_date, e_date)
    events
  end

  def get_user_connection(share_with_user)
    if self.has_connection_with(share_with_user)
      self.has_connection_with(share_with_user)
    else
      self.make_new_connection(share_with_user)
    end
  end

  def make_new_connection(user)
    connection = self.user_connections.create(connection: user)
    connection
  end

  def has_connection_with(user)
    if self.connections.include?(user)
      self.user_connections.where(connection: user).first
    elsif self.inverse_connections.include?(user)
      user.user_connections.where(connection: self).first
    else
      nil
    end
  end

  def create_default_working_days
    unless self.working_days.present?
      self.working_days.create(work_day: 0, start_time: '06:00', end_time: '21:00', opened: 'false')
      self.working_days.create(work_day: 1, start_time: '06:00', end_time: '21:00', opened: 'true')
      self.working_days.create(work_day: 2, start_time: '06:00', end_time: '21:00', opened: 'true')
      self.working_days.create(work_day: 3, start_time: '06:00', end_time: '21:00', opened: 'true')
      self.working_days.create(work_day: 4, start_time: '06:00', end_time: '21:00', opened: 'true')
      self.working_days.create(work_day: 5, start_time: '06:00', end_time: '21:00', opened: 'true')
      self.working_days.create(work_day: 6, start_time: '06:00', end_time: '21:00', opened: 'false')
    end
  end

  def pretty_name
    fullname
  end

  def category
    self.categories.first || {}
  end

  rails_admin do
    configure :set_password

    edit do
      exclude_fields :password, :password_confirmation
      include_fields :set_password
    end
    object_label_method do
      :pretty_name
    end

    field :first_name
    field :last_name
  end

  def skilled_status
    is_skilled ? "Yes" : "No"
  end

  def fullname
    "#{first_name} #{last_name}"
  end

  def is_fb_user
    uid.present?
  end

  # Provided for Rails Admin to allow the password to be reset
  def set_password; nil; end

  def set_password=(value)
    return nil if value.blank?
    self.password = value
    self.password_confirmation = value
  end

  def admin
    self.role == "admin"
  end

  def gender_enum
    ['Male', 'Female']
  end

  def role_enum
    ['admin', 'appuser']
  end


  # Assign an API Token on create
  before_create do |user|
    user.api_token = User.generate_api_token
    user.refer_code = User.generate_refer_token
  end

  # Generate a unique API Token
  def self.generate_api_token
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless User.exists?(api_token: token)
    end
  end

  def self.generate_refer_token
    loop do
      token = rand(36**8).to_s(36)
      break token unless User.exists?(refer_code: token)
    end
  end

  def update_user_api_token(create_new=false)
    self.api_token = create_new ? User.generate_api_token : nil
    self.save(:validate => false)
  end

  # def user_image
  #   if self.profile_img.present?
  #     path = self.profile_img
  #   else
  #     path = ENV['MY_HOST'].to_s+"/images/user.png"
  #   end
  #   path
  # end

  # def working_slots
  #   @user.working_days.create(params[])
  # end

  def user_cover
    if self.cover_img.present?
      path = self.cover_img
    else
      path = ENV['MY_HOST'].to_s+"/images/user.png"
    end
    path
  end

  def setup_devices(token,platform)
    self.de_active_devices
    device = self.user_devices.where(push_token: token, platform: platform).first_or_create
    device.set_active
  end

  def de_active_devices
    self.user_devices.update_all(is_active: false)
  end

  def send_push
    if self.user_devices.active.first.present?
      response = FcmPush.new.send_push_notification('','','')
      self.push_logs.new.save_log(response)
    end
  end

  def active_device
    self.user_devices.active.first
  end

  def endorsement_count
    endorsements.count
  end

  def total_likes_on_posts
    total_count = 0
    posts.each do |post|
      total_count+=post.post_likes.count
    end
    total_count
  end

  def title
    skill || {}
  end

  def is_confirmed
    confirmed_at.present?
  end

  def availability
    self.working_days
  end

  # Start: Payment related methods

  def total_earnings(event_ids = events.pluck(:id))
    Charge.where("event_id IN(?)", event_ids).sum(:amount)
  end

  def total_payouts(event_ids = events.pluck(:id))
    #Payment.where("event_id IN(?)", event_ids).sum(:amount)
    Payment.where("user_id = ?", id).sum(:amount)/100
  end

  def balanced_amount
    (total_earnings/100 - total_payouts)
  end

  # def jobs_as_worker
  #   Job.where(id: self.bids.accepted.pluck(:job_id))
  # end
  #
  # def worker_total_jobs
  #   jobs_as_worker.count
  # end
  #
  # def employer_total_jobs
  #   self.jobs.count
  # end
  #
  # def hours_worked
  #   Job.where(id: self.bids.accepted.pluck(:job_id), status: 'completed').sum(:hours)
  # end
  #
  # def hours_paid
  #   self.jobs.where(status: 'completed').sum(:hours)
  # end
  #
  #
  # def details
  #   {
  #       total_earnings: self.total_earnings,
  #       worker_total_jobs: self.worker_total_jobs,
  #       hours_worked: self.hours_worked,
  #
  #       total_spending: self.total_spending,
  #       employer_total_jobs: self.employer_total_jobs,
  #       hours_paid: self.hours_paid,
  #
  #       received_reviews: self.received_reviews.includes(:reviewer)
  #   }
  # end
  #
  # def worker_completion_rate
  #   jobs_as_worker.completed.count.to_f / worker_total_jobs.to_f * 100.0
  # end
  #
  # def my_earning_details
  #   total_earnings = self.empolyee_charges.map{|c| c.amount - c.job_caf_share}.sum / 100.0
  #   available_earnings = self.empolyee_charges.map{|c| c.approved ? (c.amount - c.job_caf_share) : 0.0 }.sum / 100.0
  #   pending_earnings = self.empolyee_charges.map{|c| !c.approved ? (c.amount - c.job_caf_share) : 0.0 }.sum / 100.0
  #   total_claimed = self.payments.map(&:amount).sum / 100.0
  #   {
  #       total_earnings: total_earnings,
  #       available_earnings: available_earnings,
  #       pending_earnings: pending_earnings,
  #       total_claimed: total_claimed,
  #       claimable_amount: available_earnings - total_claimed,
  #       details: self.empolyee_charges
  #   }
  # end
  #
  # def my_payment_details
  #   total_payments = self.empolyer_charges.map{|c| c.amount - c.job_caf_share}.sum / 100.0
  #   payments_approved = self.empolyer_charges.map{|c| c.approved ? (c.amount - c.job_caf_share) : 0.0 }.sum / 100.0
  #   payments_pending = self.empolyer_charges.map{|c| !c.approved ? (c.amount - c.job_caf_share) : 0.0 }.sum / 100.0
  #   {
  #       total_payments: total_payments,
  #       payments_approved: payments_approved,
  #       payments_pending: payments_pending,
  #       details: self.empolyer_charges
  #   }
  # end
  #
  # def my_payouts
  #   total_payout = self.payments.map(&:amount).sum / 100.0
  #   {
  #       total_payout: total_payout,
  #       details: self.payments
  #   }
  # end
  # End: Payment related methods

  def get_bank_details
    success = false
    errors="There is no stripe payout token for this user"
    external_accounts={}
    if self.stripe_payout_token.present?
      begin
        account= Stripe::Account.retrieve(self.stripe_payout_token)
        external_accounts = account.external_accounts
        success = true
      rescue Stripe::StripeError => e
        success = false
        errors = e.error.message
      end
    end
    {success: success, errors: errors, external_accounts: external_accounts}
  end

  def attributes
    {id: self.id, email: self.email, first_name: self.first_name, last_name: self.last_name, created_at: self.created_at,
     updated_at: self.updated_at, phone: self.phone, gender: self.gender, zipcode: self.zipcode, city: self.city, state: self.state, country: self.country, dob: self.dob, address: self.address, profile_img: self.profile_img, cover_img: self.cover_img, is_skilled: self.is_skilled, latitude: self.latitude, longitude: self.longitude, stripe_token: self.stripe_token, stripe_payout_token: self.stripe_payout_token, api_token: self.api_token}
  end

  def has_endorsed(user_id)
    self.endorsements.pluck(:endorsed_by_id).include?(user_id.to_i)
  end

  def has_connection(user_id)
    status=0
    status=1 if self.req_connection_with_user(user_id.to_i).present?
    status=2 if self.verified_with_user(user_id.to_i).present?
    status
  end

  def pending_user_requests

  end

  def as_json(options={})
    opts = {
        methods: [:endorsement_count, :total_likes_on_posts, :title, :is_confirmed, :category, :availability]
    }
    json_to_return=super(options.merge(opts))
    json_to_return[:has_endorsed] = has_endorsed(options[:current_user_id]) if options[:current_user_id].present?
    json_to_return[:has_connection] = has_connection(options[:current_user_id]) if options[:current_user_id].present?
    json_to_return[:push_token] = user_devices.active.pluck(:push_token)[0]
    
    return json_to_return
  end


  #GB: Fields to be displayed in filter dropdown on listing page
  def self.filter_fields
    {
        email: 'Email',
        first_name: 'First Name',
        last_name: 'Last Name',
        phone: 'Phone'
    }
  end

  def self.dropdown_options
    all.map{|s| [s.fullname, s.id]}
  end

  def user_age
    begin
      self.dob.present? ? (Date.today - Date.parse(self.dob)).to_i/365 : nil
    rescue
      return nil
    end
  end

  def self.get_age(date)
    begin
      date.present? ? (Date.today - Date.parse(date)).to_i/365 : nil
    rescue
      return nil
    end
  end


  def self.search(options = {})
    users = User.all.confirmed
    users = users.near([options[:latitude], options[:longitude]], options[:distance] || 5, units: :km) if options[:latitude].present? && options[:longitude].present?
    users= users.where("dob >= ? OR dob IS NULL", (Date.today-options[:max_age].to_i.years).to_s.gsub('-', "/")) if options[:max_age].present?
    users = users.where("dob <= ? OR dob IS NULL", (Date.today-options[:min_age].to_i.years).to_s.gsub('-', "/")) if options[:min_age].present?
    users = users.where("is_skilled=?", options[:skilled]) if options[:skilled].present?
    users = users.where("gender ILIKE ?", options[:gender]) if options[:gender].present?
    # by/ebug
    if options[:skill].present?
      skills = options[:skill].split(",")
      skill_qry =  options[:skill].to_i.eql?(0) ? "skills.title ILIKE ?" : "skills.id IN (?)"
      users = users.joins(:skill).where(skill_qry, skills).distinct
    end
    if options[:sub_skill].present?
      sub_skills = options[:sub_skill].split(",")
      sub_skill_qry =  options[:sub_skill].to_i.eql?(0) ? "sub_skills.title ILIKE ?" : "sub_skills.id IN (?)"
      users = users.joins(:sub_skill).where(sub_skill_qry, sub_skills).distinct
    end
    if options[:category].present?
      categories = options[:category].split(",")
      users= users.joins(:categories).where("categories.id IN (?)", categories).distinct
    end
    users
  end

  def get_events_by_user_tickets
    # e = self.tickets.select(:event_id).group(:event_id).count.keys
    # Event.where("id IN(?)",e)
    Event.joins(:tickets).where(tickets: {owner_id: self.id}).uniq
  end

  # It will return list of event you have registerd by you did not post a review yet
  def get_unreviewed_events
    Event.published.completed.joins(:tickets).left_outer_joins(:reviews).where(tickets: {owner_id: self.id}, reviews: {id: nil}).uniq
  end

  def self.user_search_condition(search_for)
    User.confirmed.ransack(first_name_or_email_or_phone_start: search_for, sub_skill_title_start: search_for ,skill_title_start: search_for, categories_title_start: search_for, m: 'or').result
  end

end

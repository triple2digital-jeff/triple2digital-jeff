# == Schema Information
#
# Table name: services
#
#  id                  :bigint           not null, primary key
#  cover_image         :text             default("http://app.profilerlife.com/images/default_cover.png")
#  duration            :string
#  is_private          :boolean          default(FALSE)
#  note                :text
#  price               :float
#  status              :string
#  time_type           :string           default("minutes")
#  title               :string
#  video_url           :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  owner_id            :integer
#  service_category_id :integer
#

class Service < ApplicationRecord

  TYPES = ['minutes', 'hourly']

  ############ Associations ##############
  belongs_to :owner, class_name: 'User'
  belongs_to :service_category, optional: true
  has_many :appointments, dependent: :destroy
  has_many :users, through: :appointments

  include Reviewable
  has_many :saved_events, as: :saveable, dependent: :destroy

  ############ Validations ##############

  validates :title, :duration, :time_type, presence: true
  validate :validate_type

  # after_create :generate_appointments

  def validate_type
    errors.add(:working_day, 'Time type should be minutes or hourly.') unless TYPES.include?(time_type)
  end

  def days_timings
    owner.availability
  end

  def average_rating
    {rating: reviews.average(:rating).to_f, based_on_count: reviews.count}
  end

  # Need Optimization
  def check_time_slot_availability(for_date)

    w_day = self.owner.working_days.find_by_work_day(for_date.wday)
    all_data = w_day.present? ? w_day.serializable_hash : {}
    all_slots =[]
    if w_day && w_day.opened
      s_time = w_day.calculate_start_time(w_day.start_time, self.duration_in_minutes)
      end_time = calculate_end_time(s_time, self.duration_in_minutes)
      booked_time_slots = self.appointments.on(for_date).pluck(:start_time, :end_time)
      i=0 #for loop control
      until ((end_time > w_day.end_time) || (i > 100)) do
        i=i+1
        available = true
        booked_time_slots.each do |t|
          available = false if t[0] == s_time
        end
        slot = {start_time: s_time, end_time: end_time, available: available}
        all_slots.push(slot)
        s_time = w_day.calculate_start_time(end_time, self.duration_in_minutes)
        end_time = calculate_end_time(s_time, self.duration_in_minutes)
      end
    end
    all_data[:all_slots] = all_slots
    all_data
  end

  #For Test only
  def generate_appointments
    if self.owner and self.owner.working_days.present?
      self.owner.working_days.opened_days.by_day.each do |d|

        s_time = d.get_start_time_for_slot
        end_time = calculate_end_time(s_time, self.duration_in_minutes)
        until end_time > d.end_time do
          self.appointments.create(working_day_id: d.id, start_time: s_time, end_time: end_time)
          s_time = d.get_start_time_for_slot
          end_time = calculate_end_time(s_time, self.duration_in_minutes)
        end

        # d.appointments.create()
      end
    end
  end

  def self.search(options = {})
    services = Service.all
    services = services.where(owner_id: options[:user_id]) if options[:user_id].present?
    if options[:latitude].present? && options[:longitude].present?
      user_ids=[]
      user_ids = User.near([options[:latitude], options[:longitude]], options[:distance] || 5, units: :km).to_a.map(&:id)
      services = services.where("owner_id IN(?)", user_ids)
    end
    services = services.where("price >= ?", options[:min_price]) if options[:min_price].present?
    services = services.where("price <= ?", options[:max_price]) if options[:max_price].present?
    if options[:category].present?
      services = services.where("service_category_id=?", options[:category])
    end
    services
  end

  def duration_in_minutes
    (time_type == 'hourly') ? (duration.to_i)*60 : duration.to_i
  end

  def calculate_end_time(start_time, duration)
    (Time.parse(start_time)+duration.minutes).strftime("%H:%M")
  end

  def self.filter_fields
    {
        title: 'Title',
        note: 'Note'
    }
  end

  def self.units_of_time_dropdown
    ['Minutes', 'Hours', 'Days', 'Weeks', 'Month']
  end

  def as_json(options = {})
    json_to_return = super
    # byebug
    json_to_return[:is_saved] = has_saved_service(options[:user_id]) if options[:user_id].present?

    return json_to_return
  end

  def has_saved_service(user)
    # return 'true'
    user.my_saved_services.include? self
  end

end

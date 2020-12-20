# == Schema Information
#
# Table name: working_days
#
#  id               :bigint           not null, primary key
#  break_end_time   :string
#  break_start_time :string
#  end_time         :string
#  has_break        :boolean          default(FALSE)
#  opened           :boolean
#  start_time       :string
#  work_day         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#

class WorkingDay < ApplicationRecord

  WORKDAYS=[0,1,2,3,4,5,6]
  ############ Associations ##############
  belongs_to :user
  scope :opened_days, -> {where('opened IS TRUE')}
  scope :closed_days, -> {where('opened IS FALSE')}
  scope :by_day,      -> {order("work_day ASC")}


  ############ Validations ##############

  validates :start_time, :end_time, :work_day, presence: true
  validates :work_day, uniqueness: { scope: :user }
  validate :validate_day


  def validate_day
    errors.add(:working_day, 'Work Day  should be from 0 to 6.') unless WORKDAYS.include?(work_day.to_i)
    errors.add(:working_day_times, 'Work Day  should be from 0 to 6.') unless WORKDAYS.include?(work_day.to_i)
    if has_break && break_start_time.present? && break_end_time.present?
      errors.add(:working_day_time, 'break start time can not be greater or equal to break end time') if break_start_time >= break_end_time
      errors.add(:working_day_start_time, 'invalid break start time') if ((break_start_time > end_time) || (break_start_time < start_time) )
      errors.add(:working_day_end_time, 'invalid break end time') if ((break_end_time > end_time) || (break_end_time < start_time) )
    end
  end

  def get_start_time_for_slot
    # if self.appointments.present?
    self.appointments.try(:last).try(:end_time) || self.start_time
    # end
  end

  def calculate_start_time(s_time, duration)
    start_time = s_time
    next_time = (Time.parse(start_time)+duration.minutes).strftime("%H:%M")
    if has_break && break_start_time && break_end_time
      if (next_time > break_start_time) && (break_end_time > next_time)
        start_time = break_end_time
      end
    end
    start_time
  end

end

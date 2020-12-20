# == Schema Information
#
# Table name: appointments
#
#  id               :bigint           not null, primary key
#  appointment_date :date
#  end_time         :string
#  is_booked        :boolean          default(FALSE)
#  note             :text
#  start_time       :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  service_id       :bigint
#  user_id          :bigint
#  working_day_id   :integer
#
# Indexes
#
#  index_appointments_on_service_id  (service_id)
#  index_appointments_on_user_id     (user_id)
#

class Appointment < ApplicationRecord

  ############ Scopes ##############
  default_scope {order("created_at ASC")}
  scope :on, -> (date) { where("appointment_date=?", date) }
  ############ Associations ##############
  belongs_to :service
  belongs_to :user, optional: true

  ############ Validations ##############
  validates :start_time, :end_time, :appointment_date, presence: true

  def self.filter_fields
    {
        id: 'No'
    }
  end
end

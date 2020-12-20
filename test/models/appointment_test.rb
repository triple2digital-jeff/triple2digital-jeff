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

require 'test_helper'

class AppointmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

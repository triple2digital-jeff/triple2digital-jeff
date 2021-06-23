# == Schema Information
#
# Table name: users
#
#  id                      :bigint           not null, primary key
#  address                 :string
#  age                     :string
#  api_token               :string
#  city                    :string
#  confirmation_sent_at    :datetime
#  confirmation_token      :string
#  confirmed_at            :datetime
#  country                 :string
#  cover_img               :string           default("http://app.profilerlife.com/images/default_cover.png")
#  dob                     :string
#  email                   :string           default(""), not null
#  encrypted_password      :string           default(""), not null
#  first_name              :string
#  free_events             :integer          default(0)
#  gender                  :string
#  is_book_service         :boolean          default(TRUE), not null
#  is_cancel_appointment   :boolean          default(TRUE), not null
#  is_comments             :boolean          default(TRUE), not null
#  is_endrose              :boolean          default(TRUE), not null
#  is_event_details        :boolean          default(TRUE), not null
#  is_extra_event_added    :boolean          default(FALSE)
#  is_guest_refer_vc_added :boolean          default(FALSE)
#  is_likes                :boolean          default(TRUE), not null
#  is_service_notes        :boolean          default(TRUE), not null
#  is_shares               :boolean          default(TRUE), not null
#  is_skilled              :boolean          default(FALSE)
#  is_tickets_sold         :boolean          default(TRUE), not null
#  is_upcoming_events      :boolean          default(TRUE), not null
#  last_name               :string
#  latitude                :float
#  longitude               :float
#  phone                   :string
#  profile_img             :string           default("http://app.profilerlife.com/images/user.png")
#  provider                :string
#  refer_by                :string
#  refer_code              :string
#  remember_created_at     :datetime
#  reset_password_sent_at  :datetime
#  reset_password_token    :string
#  role                    :string
#  state                   :string
#  stripe_payout_token     :string
#  stripe_token            :string
#  uid                     :string
#  unconfirmed_email       :string
#  zipcode                 :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  skill_id                :integer
#  sub_skill_id            :integer
#  voucher_customer_id     :string
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

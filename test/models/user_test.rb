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
#  is_skilled             :boolean          default(FALSE)
#  last_name              :string
#  latitude               :float
#  longitude              :float
#  phone                  :string
#  profile_img            :string           default("http://app.profilerlife.com/images/user.png")
#  provider               :string
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

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

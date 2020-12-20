# == Schema Information
#
# Table name: payments
#
#  id                 :bigint           not null, primary key
#  amount             :float
#  status             :integer          default(0)
#  stripe_response    :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  event_id           :integer
#  stripe_payment_id  :string
#  stripe_transfer_id :string
#  user_id            :integer
#

class Payment < ApplicationRecord
  ############ Associations ##############
  belongs_to :user
  # belongs_to :event
  ############ Scopes ##############

  ############ Validations ##############


  def self.search(options = {})
    payments = Payment.all
    payments = payments.where("user_id=?", options[:user]) if options[:user].present?
    payments
  end

end

# == Schema Information
#
# Table name: outgoing_payments
#
#  id         :bigint           not null, primary key
#  amount     :float            default(0.0)
#  status     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :integer
#  user_id    :integer
#

class OutgoingPayment < ApplicationRecord

  ############ Associations ##############
  belongs_to :user
  belongs_to :event
  ############ Scopes ##############

  ############ Validations ##############


  def self.search(options = {})
    payments = OutgoingPayment.all
    payments = payments.where("user_id=?", options[:user]) if options[:user].present?
    payments = payments.where("event_id=?", options[:event]) if options[:event].present?
    payments = payments.where("created_at >= ?", options[:date_from]) if options[:date_from].present?
    payments = payments.where("created_at <= ?", options[:date_to]) if options[:date_to].present?
    payments
    payments
  end

end

# == Schema Information
#
# Table name: charges
#
#  id              :bigint           not null, primary key
#  amount          :float
#  approved        :boolean          default(FALSE)
#  boolean         :boolean          default(FALSE)
#  company_share   :float
#  disputed        :boolean          default(FALSE)
#  refunded        :boolean          default(FALSE)
#  stripe_response :text
#  total_amount    :float
#  vc_amount       :float
#  vc_code         :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  event_id        :integer
#  owner_id        :integer
#  stripe_id       :string
#  user_id         :integer
#

class Charge < ApplicationRecord

  ############ Associations ##############
  belongs_to :owner, class_name: 'User'
  belongs_to :user
  belongs_to :event
  ############ Scopes ##############

  ############ Validations ##############

  def self.search(options = {})
    charges = Charge.all
    charges = charges.where("owner_id=?", options[:owner]) if options[:owner].present?
    charges = charges.where("user_id=?", options[:user]) if options[:user].present?
    charges = charges.where("event_id=?", options[:event]) if options[:event].present?
    charges = charges.where("created_at >= ?", options[:date_from]) if options[:date_from].present?
    charges = charges.where("created_at <= ?", options[:date_to]) if options[:date_to].present?
    charges
  end

end

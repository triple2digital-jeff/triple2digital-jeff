# == Schema Information
#
# Table name: tickets
#
#  id                :bigint           not null, primary key
#  expire_date       :datetime
#  has_scanned       :boolean          default(FALSE)
#  is_expired        :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  event_id          :integer
#  owner_id          :integer
#  ticket_package_id :integer
#

class Ticket < ApplicationRecord
  ############ Associations ##############
  belongs_to :event
  belongs_to :owner, class_name: 'User', optional: true
  belongs_to :ticket_package

  scope :available, -> { where(owner_id: nil) }
  scope :not_available, -> { where('tickets.owner_id IS NOT NULL') }
  scope :sold, -> { not_available }

  def self.set_tickets
    TicketPackage.all.each do |tp|
      expire_date = tp.event.try(:end_date)
      (1..tp.maximum_tickets).each { |i| Ticket.create!(is_expired: false, event_id: tp.event_id, owner_id: nil, ticket_package_id: tp.id, expire_date: expire_date) } if tp.event.present?
    end
  end

end

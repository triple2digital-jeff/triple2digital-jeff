# == Schema Information
#
# Table name: ticket_packages
#
#  id              :bigint           not null, primary key
#  maximum_tickets :integer          default(0)
#  price           :float            default(0.0)
#  ticket_type     :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  event_id        :integer
#

class TicketPackage < ApplicationRecord
  ############ Associations ##############
  belongs_to :event
  has_many :tickets

  # include Reviewable

  ############ Validations ##############

  validates :ticket_type, :maximum_tickets, :price, presence: true

  ############ Callbacks ##############
  after_create :generate_tickets

  # accepts_nested_attributes_for :ticket_packages
  #GB: Fields to be displayed in filter dropdown on listing page
  # def self.filter_fields
  #   {
  #       title: 'Title',
  #       status: 'Status'
  #   }
  # end
  #
  def attributes
    {
        id: self.id,
        ticket_type: self.ticket_type,
        price: self.price,
        maximum_tickets: self.maximum_tickets,
        available_tickets: self.available_tickets
    }
  end

  def available_tickets
    self.tickets.available.count
  end

  private

  def generate_tickets
    expire_date = self.event.end_date
    (1..self.maximum_tickets).each { |i| self.tickets.create(is_expired: false, event_id: self.event_id, owner_id: nil, ticket_package_id: self.id, expire_date: expire_date) }
  end
end

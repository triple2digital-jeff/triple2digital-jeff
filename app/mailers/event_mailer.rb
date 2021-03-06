class EventMailer < ApplicationMailer

  def event_registration(buyer, total_tickets, ticket_package, event, total_price, tickets, external_user)
    @buyer =  buyer
    @total = total_tickets
    @packegs= ticket_package
    @event = event
    @total_price = total_price
    @tickets = tickets
    @external_user_p = external_user
    mail(to: @buyer.email, subject: 'You Have Purcahsed Tickets For Event '+ event.title, from: "connect@profilerlife.com")
  end

  def contact_as(user, content, subject)
    @user = user
    @content = content
    mail(to: "connect@profilerlife.com", from: user.email, subject: subject)
  end
end

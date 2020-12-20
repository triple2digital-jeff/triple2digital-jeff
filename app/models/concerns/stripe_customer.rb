class StripeCustomer
  attr_accessor :user, :amount, :event, :owner, :errors
  def initialize(user, amount = 100 , event = nil)
    self.user = user
    self.amount = amount.to_f
    self.event = event
    self.owner = event.owner if event
  end

  def charge
    success = true
    company_share = self.amount * 25.0 / 100.0
    total_amount = (self.amount + company_share) * 100.0

    begin
      stripe_charge = Stripe::Charge.create({
                      amount: total_amount.to_i,
                      currency: 'usd',
                      customer: self.user.stripe_token,
                      description: "user id => #{self.user.id} and owner_id => #{self.owner.id} and event_id => #{self.event.id}",
                      capture: true
                  })

      Charge.create!(
          amount: total_amount,
          stripe_id: stripe_charge[:id],
          company_share: company_share * 100.0,
          user_id: self.user.id,
          owner_id: self.owner.id,
          event_id: self.event.id,
          stripe_response: stripe_charge
      )
    rescue Stripe::StripeError => e
      success = false
      self.errors = e.error.message if e.error.present?
    end
    success
  end

  def transfer
    success = true
    begin
      payment = Stripe::PaymentIntent.create({
                                                 payment_method: 'pm_card_visa',
                                                 amount: (self.amount * 100.0).to_i,
                                                 currency: 'usd',
                                                 transfer_data: {
                                                     destination: self.user.stripe_payout_token,
                                                 },
                                                 confirm: true
                                             })
      Payment.create!(
                 amount: self.amount * 100.0,
                 user_id:  self.user.id,
                 # event_id: self.event.id,
                 stripe_payment_id: payment.id,
                 stripe_transfer_id: '',
                 stripe_response: payment)
    rescue Stripe::StripeError => e
      success = false
      self.errors = e.error.message
    end
    success
  end


  def self.accept_terms(token)
    Stripe::Account.update(
        token,
        {
            tos_acceptance: {
                date: Time.now.to_i,
                ip: "8.8.8.8", # Assumes you're not using a proxy
            },
        }
    )
  end

  def self.create_customer(email, token, user)
    if user.stripe_token.blank?
      customer = Stripe::Customer.create(
          email: email,
          source: token
      )
      user.update(stripe_token: customer.id)
    else
      customer = Stripe::Customer.retrieve(stripe_token)
    end
    customer
  end
end

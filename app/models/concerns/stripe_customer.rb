class StripeCustomer
  attr_accessor :user, :amount, :event, :owner, :errors, :params
  def initialize(user, amount = 100 , event = nil, params = {})
    self.user = user
    self.amount = amount.to_f
    self.event = event
    self.owner = event.owner if event
    self.params = params
  end

  def charge
    success = true
    total = 0
    company_share = 0
    vc_amount = 0
    params['event']['ticket_packages'].each do |package|
      if package['required_tickets'].present?
        single_fee = (package['price'] * 4.4 / 100.0) + 0.80
        company_share = company_share + single_fee*package['required_tickets']
        total = total + (package['price']*package['required_tickets'])
      end
    end
    if params['event']['voucher_code'].present?
      voucher = Voucher.find_by(code: params['event']['voucher_code'])
      if voucher.present? && voucher.active
        vc_amount = (total*voucher.discount)/100
        total = total - vc_amount
        voucher.update(active: false)
        VoucherApiService.new().redeem_voucher(voucher)
      end
    end
    if self.event.is_free_event
      actual_amount = total * 100.0
      total_amount = (total) * 100.0
      company_share = 0
    elsif self.event.is_tax_by_creator
      total_amount = (total) * 100.0
      actual_amount = (total - company_share) * 100.0
    else
      #total = total * 100.0
      total_amount = (total + company_share) * 100.0
      actual_amount = total * 100.0
    end

    begin
      puts "test #{total_amount}"
      stripe_charge = Stripe::Charge.create({
                      amount: total_amount.to_i,
                      currency: 'usd',
                      customer: self.user.stripe_token,
                      description: "user id => #{self.user.id} and owner_id => #{self.owner.id} and event_id => #{self.event.id}",
                      capture: true
                  })

      Charge.create!(
          total_amount: total_amount,
          amount: actual_amount,
          stripe_id: stripe_charge[:id],
          company_share: company_share * 100.0,
          user_id: self.user.id,
          owner_id: self.owner.id,
          event_id: self.event.id,
          stripe_response: stripe_charge,
          vc_code: params['event']['voucher_code'],
          vc_amount: vc_amount
      )
    rescue Stripe::StripeError => e
      success = false
      self.errors = e.error.message if e.error.present?
    end
    success
  end

  def web_charge
    success = true
    total = 0
    company_share = 0
    vc_amount = 0
    params['event']['ticket_packages'].each do |package|
      if package['required_tickets'].present?
        single_fee = (package['price'] * 4.4 / 100.0) + 0.80
        company_share = company_share + single_fee*package['required_tickets']
        total = total + (package['price']*package['required_tickets'])
      end
    end
    if self.event.is_free_event
      actual_amount = total * 100.0
      total_amount = (total) * 100.0
      company_share = 0
    elsif self.event.is_tax_by_creator
      total_amount = (total) * 100.0
      actual_amount = (total - company_share) * 100.0
    else
      #total = total * 100.0
      total_amount = (total + company_share) * 100.0
      actual_amount = total * 100.0
    end

    begin
      puts "test #{total_amount}"
      stripe_charge = Stripe::Charge.create({
                      amount: total_amount.to_i,
                      currency: 'usd',
                      customer: self.user.stripe_token,
                      description: "user id => #{self.user.id} and owner_id => #{self.owner.id} and event_id => #{self.event.id}",
                      capture: true
                  })
      Charge.create!(
          total_amount: total_amount,
          amount: actual_amount,
          stripe_id: nil,
          company_share: company_share * 100.0,
          user_id: self.user.id,
          owner_id: self.owner.id,
          event_id: self.event.id,
          stripe_response: stripe_charge,
          vc_code: params['event']['voucher_code'],
          vc_amount: vc_amount
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
      payment = Stripe::Transfer.create({
                                                  amount: (self.amount * 100.0).to_i,
                                                  currency: 'usd',
                                                  destination: self.user.stripe_payout_token,
                                                  transfer_group: 'EVENT_RETURNS',
                                                  source_type: 'card'
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
      customer = Stripe::Customer.retrieve(user.stripe_token)
    end
    customer
  end
end

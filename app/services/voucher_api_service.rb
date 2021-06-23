class VoucherApiService
  def initialize
    @voucherify = Voucherify::Client.new({
      :applicationId => Rails.application.secrets.voucherify_id,
      :clientSecretKey => Rails.application.secrets.voucherify_secret,
      :apiUrl => Rails.application.secrets.voucherify_url
    })
  end

  def create_customer(user)
    customer = {
      "source_id":user.email, 
      "name": user.fullname,
      "email": user.email,
      "address": {
        "city": user.city,
        "state": user.state,
        "line_1": user.address,
        "country": user.country,
        "postal_code": user.zipcode
      },
      "description":"Profiler user",
      "metadata": {
        "lang":"en"
      }
    }
    @voucherify.customers.create(customer)
  end

  def create_voucher(user, user_type, reason)
    offer = Offer.find_by(user_type: user_type, reason: reason)
    if offer
      options = {
        :category => reason,
        :type => 'DISCOUNT_VOUCHER',
        :discount => {
            :type => 'PERCENT',
            :percent_off => offer.percentage
        },
        "redemption": {
          "quantity": 1 
        }
      }
      response = @voucherify.vouchers.create(generate_code, options)
      user.vouchers.create(voucher_id: response["id"], code: response["code"], vc_type: response["type"], category: response["category"], discount: offer.percentage, refer_code: user.refer_code, active: response["active"], redeemed_quantity: response["redemption"]["redeemed_quantity"], redemption: response["redemption"]["quantity"], role: user_type, reason: reason)
    
    end
  end

  private

  def generate_code
    loop do
      code = rand(36**8).to_s(36)
      break code unless Voucher.exists?(code: code)
    end
  end
end
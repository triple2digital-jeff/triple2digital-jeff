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
end
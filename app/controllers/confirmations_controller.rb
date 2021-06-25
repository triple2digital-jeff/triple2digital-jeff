class ConfirmationsController < Devise::ConfirmationsController

  private

  def after_confirmation_path_for(resource_name, resource)
    VoucherApiService.new().create_voucher(resource, 'GUEST', Voucher::TYPES[1])
    user_after_confirmation_home_index_path
  end

end
class PasswordsController < Devise::PasswordsController

  def new
    super
  end

  def edit
    super
  end

  def create
    super
  end

  #override this so user isn't signed in after resetting password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      flash_message = resource.active_for_authentication? ? :updated_not_active : :updated_not_active
      set_flash_message(:notice, flash_message) if is_navigational_format?

      respond_with resource, :location => after_resetting_password_path_for(resource)
    else
      respond_with resource
    end

  end

  protected

  def after_resetting_password_path_for(resource)
    new_session_path(resource, :gst=>true)
  end
end

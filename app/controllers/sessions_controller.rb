class SessionsController < Devise::SessionsController
  # POST /resource/sign_in
  before_action :validate_user_auth, only: [:create]

  def create
    super
  end

  def validate_user_auth
    user = User.find_by_email(params[:user][:email])
    if user && !user.admin
      redirect_to "/authorization.html"
    end
  end
end
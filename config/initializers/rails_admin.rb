RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==

  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  # config.authorize_with do |controller|
  #   if current_user.nil?
  #     redirect_to main_app.new_account_session_path, flash: {error: 'Please Login to Continue..'}
  #   elsif !current_user.admin
  #     redirect_to main_app.root_path, flash: {error: 'You are not Admin bro!'}
  #   end
  # end
  config.authorize_with do
    redirect_to main_app.destroy_user_session_path unless current_user.admin
  end

  ## == Cancan ==
  # config.authorize_with :cancancan
  # config.parent_controller = 'ApplicationController'

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit do
      except ['CustomPush']
    end
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end



  config.model 'User' do

    navigation_icon 'icon-user'
    # list do
    #   field :first_name
    #   field :last_name
    # end
    include_fields :email, :password, :password_confirmation, :first_name, :last_name, :gender, :phone, :address, :role, :is_skilled
  end
  #
  # config.model 'Category' do
  #
  #   navigation_icon 'icon-folder-close'
  #   # list do
  #   #   field :first_name
  #   #   field :last_name
  #   # end
  #   include_fields :name, :description
  # end

  # config.model 'Question' do
  #
  #   navigation_icon 'icon-question-sign'
  #   include_fields :question_text, :category, :feedback, :question_options, :avatar
  #
  #
  #   # field :question_options do
  #   #   associated_collection_cache_all false  # REQUIRED if you want to SORT the list as below
  #   #   associated_collection_scope do
  #   #     # bindings[:object] & bindings[:controller] are available, but not in scope's block!
  #   #     team = bindings[:object]
  #   #     Proc.new { |scope|
  #   #       # scoping all Players currently, let's limit them to the team's league
  #   #       # Be sure to limit if there are a lot of Players and order them by position
  #   #       scope = scope.where(league_id: team.league_id) if team.present?
  #   #       scope = scope.limit(30) # 'order' does not work here
  #   #     }
  #   #   end
  #   #   searchable false
  #   # end
  #
  #   # configure :question_options do
  #   #   # hide
  #   #   # for list view
  #   #   filterable false
  #   #   searchable false
  #   # end
  #   # field :question_options do
  #   #   associated_collection_cache_all false
  #   # end
  # end

  # config.model 'QuestionOption' do
  #   visible false
  #   include_fields :choice, :is_correct
  # end
  #
  config.model 'UserDevice' do
    visible false
  end
  config.model 'Comment' do
    visible false
  end
  config.model 'Post' do
    visible false
  end
  config.model 'PostLike' do
    visible false
  end
  config.model 'PostLike' do
    visible false
  end
  # config.model 'PushLog' do
  #   visible false
  # end
  #
  # config.model 'TodayQuestionLog' do
  #   visible false
  # end
  #
  # config.model 'UserAnswer' do
  #
  #   navigation_icon 'icon-file'
  #   label "User Reports"
  #   visible false
  # end
  # config.model 'CustomPush' do
  #   navigation_icon 'icon-bell'
  #   label "Send Notification"
  #   include_fields :push_text, :users
  # end
end

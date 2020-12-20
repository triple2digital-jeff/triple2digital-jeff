module ApplicationHelper


  def face_book_users
    User.where('uid IS NOT NULL').count
  end

  def render_search_and_new_btn(filter_fields, search_path, new_path, new_btn_text, show_create_button=true)
    new_btn_instructions = {new_path: new_path, new_btn_text: new_btn_text}
    form_instructions    = {filter_fields:filter_fields, search_path: search_path}

    render partial: 'shared/search_form', locals: {show_create_button: show_create_button, new_button: new_btn_instructions, form_instructions: form_instructions}
  end

  def is_current_navigation_sidebar?(controller, action=params[:action])
    'active' if params[:controller] == controller && params[:action] == action
  end

  def user_engagement_notifier(activity_count)
    if activity_count < 1
      'danger'
    elsif activity_count < 5
      'warning'
    else
      'success'
    end
  end

  def user_profile_picture(user)
    # host = Rails.env == 'production' ? 'https://nptequiz.herokuapp.com' :'http://localhost:3000'
    if user.avatar.attached?
      path = Rails.application.routes.url_helpers.rails_blob_path(user.avatar, only_path: true)
    else
      path = image_path("user.png")
    end
    (ENV['MY_HOST'].to_s+path)
  end
end

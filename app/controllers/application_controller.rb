class ApplicationController < ActionController::Base


  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  def after_sign_in_path_for(resource)
    "/home"
  end


  def render_json_response(json, status)
    render json: json, status: status
  end
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone, :is_skilled])
  end

  def search_condition(model_class)
    if params[:search_by].present?
      "LOWER(#{params[:search_by]}) LIKE '%#{params[:search_for].downcase}%'"
    elsif params[:search_for].present?
      [make_query_for_all_fields(model_class.filter_fields), search_for: "%#{params[:search_for].downcase}%"]
    else
      {}
    end
  end

  def make_query_for_all_fields(filter_fields)
    query = ''
    filter_fields.keys.each do |k|
      if filter_fields.keys.last == k
        query += "LOWER(#{k.to_s}) LIKE :search_for "
      else
        query += "LOWER(#{k.to_s}) LIKE :search_for OR "
      end
    end
    query
  end
end

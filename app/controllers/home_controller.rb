class HomeController < ApplicationController

  before_action :authenticate_user!, except: [:handle_no_rout, :user_after_confirmation, :chat_room]
  before_action :set_from_to_date

  def handle_no_rout
    render :json => {:error => "Routing Error: Invalid url"}, :status => 404
  end

  def index
    populate_chart_data
    @recent_users    = User.last(6)
    @recent_posts    = Post.last(6)
    @recent_services = Service.last(6)
    render layout: 'home'
  end

  def user_after_confirmation
    render layout: 'application'
  end

  def users_report
    populate_user_data
    respond_to do |format|
      format.js {render 'users_report.js'}
    end
  end

  def posts_report
    populate_post_data
    respond_to do |format|
      format.js {render 'posts_report.js'}
    end
  end


  def services_report
    populate_services_data
    respond_to do |format|
      format.js {render 'services_report.js'}
    end
  end

  def chat_room
  end

  private
  def populate_chart_data
    populate_user_data
    populate_post_data
    populate_services_data
  end

  def set_from_to_date
    if params[:users_report].present?
      @users_from = params[:users_report][:from]
      @users_to   = params[:users_report][:to]
    else
      @users_from = Date.today.prev_month.at_beginning_of_month.to_s
      @users_to   = Date.today.prev_month.at_end_of_month.to_s
    end
    if params[:posts_report].present?
      @posts_from = params[:posts_report][:from]
      @posts_to   = params[:posts_report][:to]
    else
      @posts_from = Date.today.prev_month.at_beginning_of_month.to_s
      @posts_to   = Date.today.prev_month.at_end_of_month.to_s
    end
  end

  def populate_user_data
    @user_data = []
    last_month_users = User.select('count(id) count').where(created_at: @users_from..@users_to).group('created_at::date, id')
    Date.parse(@users_from).upto(Date.parse(@users_to)).each do |day|
      users = last_month_users.where('created_at::date = ?', day).first
      @user_data << (users.present? ? users.count : 0)
    end
  end

  def populate_post_data
    @posts_data = []
    last_month_posts = Post.select('count(id) count').where(created_at: @posts_from..@posts_to).group('created_at::date, id')
    Date.parse(@posts_from).upto(Date.parse(@posts_to)).each do |day|
      posts = last_month_posts.where('created_at::date = ?', day).first
      @posts_data << (posts.present? ? posts.count : 0)
    end
  end

  def populate_services_data
    if params[:services_report].present?
      @top_services = params[:services_report][:top_services].to_i
    else
      @top_services = 5
    end
    @services_data = {}
    demanded_services = Service.select('title, count(appointments.id) count').joins(:appointments).group(:title).order(count: :desc).first(@top_services)
    demanded_services.each {|s| @services_data[s.title] = s.count }
  end

end
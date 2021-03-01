class Api::V1::PostsController < ApplicationController

  # skip_before_action :verify_authenticity_token

  before_action :verify_api_token#, except: [:create]
  before_action :find_user, only: [:like_post, :share_post, :index, :post_reactions]
  before_action :set_post, only: [:show, :update, :destroy, :like_post, :share_post, :post_reactions, :report_post, :repost]

  # GET /posts
  def index
    @posts = @user.posts
    @posts = (@user.posts+@user.connection_posts+@user.endorsement_posts).uniq if ["false", false].include? params[:is_profile]

    total_feeds = @posts.map{ |p| p.as_json(include: {comments:{}, user:{methods: [:title, :is_confirmed]}, current_user_id: @user.id}, methods: [:likes_count, :comments_count, :shared_count, :parent_user]) }

    if ["false", false].include? params[:is_profile]
      @events = @user.events.published
      @events = (@user.events+@user.connection_events+@user.endorsement_events).uniq
      total_feeds = total_feeds + @events.map{ |e| e.as_json(include: :ticket_packages, user_id: @user) }
    end
    total_feeds = total_feeds.sort_by{ |a| a['created_at'] }.reverse
    page = params[:page] || 1
    limit = params[:limit] || total_feeds.count
    total_feeds = Kaminari.paginate_array(total_feeds).page(page).per(limit)
    render json: total_feeds.push(length: total_feeds.count, page: page, limit: limit )#.sort_by{ |a| a['created_at'] }.reverse
  end

  # GET /posts/1
  def show
    # @post.post_image = @post.profile_image
    render json: @post, include: {comments:{}, user:{methods: [:title, :is_confirmed]}}, methods: [:likes_count, :comments_count, :shared_count, :parent_user]
  end

  # POST /posts
  def create
    @post = Post.new(post_params)
    # debugger
    # @post.password=@post.password_confirmation=pass

    if @post.save
      render json: @post, include: {comments:{}, user:{methods: [ :title, :is_confirmed]}}, methods: [:likes_count, :comments_count, :shared_count, :parent_user]
    else
      render :json => {:error => "Unable to create post at this time.", error_log: @post.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      # if params[:image].present?
      #   process_post_image(@post, params[:image])
      # end
      # @post.post_image = @post.profile_image
      render json: @post, include: {comments:{}, user:{methods: [ :title, :is_confirmed]}}, methods: [:likes_count, :comments_count, :shared_count, :parent_user]
    else
      render :json => {:error => "Unable to update record this time. Please try again later.", error_log: @post.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  def repost

    if @post.touch
      # if params[:image].present?
      #   process_post_image(@post, params[:image])
      # end
      # @post.post_image = @post.profile_image
      render json: @post, include: {comments:{}, user:{methods: [ :title, :is_confirmed]}}, methods: [:likes_count, :comments_count, :shared_count, :parent_user]
    else
      render :json => {:error => "Unable to repost record this time. Please try again later.", error_log: @post.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    if @post.destroy
      render :json => {:success => "Post deleted successfully"}, :status => :ok
    else
      render :json => {:error => "Unable to delete post at this time.", error_log: @post.errors.full_messages}, :status => :unprocessable_entity
    end

  end

  def like_post
    begin
      if params[:like] == '1'
        @post.post_likes.where(liked_by: @user).first_or_create
        msg= 'liked'
        nuser = @post.user
        if nuser.is_likes
          token = nuser.user_devices.active.pluck(:push_token)
          FcmPush.new.send_push_notification('',"#{@user.first_name} liked your post",token) if token.present?
          nuser.notifications.create(notification_type: 'like_post', description: "#{@user.first_name} liked your post", notifier_id: nuser.try(:id), object_id: @post.id)
        end
      else
        @post.post_likes.find_by_liked_by_id(@user.id).try(:destroy)
        msg= 'unliked'
      end
      render :json => {:success => "Post #{msg} successfully."}, :status => :ok
    rescue
      render json: { errors: "Some thing went wrong! Try again later." }, status: :unprocessable_entity
    end
  end

  def share_post
    @new_post = @post.dup
    @new_post.user_id = @user.id
    @new_post.parent_id = @post.id
    if @new_post.save
      nuser = @post.user
      if nuser.is_shares
        token = nuser.user_devices.active.pluck(:push_token)
        FcmPush.new.send_push_notification('',"#{@new_post.user.first_name} shared your post",token) if token.present?
        nuser.notifications.create(notification_type: 'shared_post', description: "#{@new_post.user.first_name} shared your post", notifier_id: nuser.try(:id), object_id: @post.id)
      end
      render :json => @new_post, include: {comments:{}, user:{methods: [ :title, :is_confirmed]}}, methods: [:likes_count, :comments_count, :shared_count, :parent_user] #{:success => "Post has been shared successfully."}, :status => :ok
    else
      render :json => {:error => "Unable to share post this time. Please try again later.", error_log: @new_post.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  def post_reactions
    # render json: @post, include: [:user]#, methods: [:likes_count, :comments_count, :shared_count, :is_liked]
    render json: @post, include: {comments: {include: {user: {methods: [ :title, :is_confirmed]}}}, current_user_id: @user.id}, methods: [:liked_by_users,:shared_by_users, :likes_count, :comments_count, :shared_count, :parent_user]
    # render json: @user, include: {info_blocks:{}, cards: {include: :info_blocks}}
    # render json: @post, include: [:user]

  end

  def report_post
    begin
      @post.report_posts.create(user_id: params[:reported_by_id])
      render :json => {:success => "Post has been reported succesfully."}, :status => :ok
    rescue
      render :json => {:error => "Unable to report at this time"}, :status => :unprocessable_entity
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    begin
      @post = Post.find(params[:id])
    rescue
      render :json => {:error => "Post not found with provided id"}, :status => 404
    end
  end

  def find_user
    begin
      @user =  User.find(params[:liked_by_id] || params[:user_id])
      render :json => {:error => "User is not activated. Please check your email #{@user.email} for user activation."} unless @user.is_confirmed
    rescue
      render :json => {:error => "User not found with provided id"}, :status => 404
    end
  end


  # Only allow a trusted parameter “white list” through.
  def post_params
    params.require(:post).permit(:description, :image_url, :video_url, :privacy, :post_type, :user_id, :is_hidden, :parent_id)
  end

  def verify_api_token
    return true if authenticate_token
    render json: { errors: "Access denied" }, status: 401
  end

  def authenticate_token
    return false if params[:api_token].blank?
    User.find_by(api_token: params[:api_token])
  end


end
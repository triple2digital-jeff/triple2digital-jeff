class ReportPostsController < ApplicationController
  before_action :authenticate_user!


  before_action :set_report_post, only: [:show, :edit, :update, :destroy]
  layout 'home'
  # GET /report_posts
  # GET /report_posts.json
  def index
    @report_posts = ReportPost.all.page(params[:page])
  end

  # GET /report_posts/1
  # GET /report_posts/1.json
  def show
  end

  # GET /report_posts/new_admin
  def new
    @report_post = ReportPost.new
  end

  # GET /report_posts/1/edit
  def edit
  end

  # POST /report_posts
  # POST /report_posts.json
  def create
    @report_post = ReportPost.new(report_post_params)

    respond_to do |format|
      if @report_post.save
        format.html { redirect_to @report_post, notice: 'ReportPost was successfully created.' }
        format.json { render :show, status: :created, location: @report_post }
      else
        format.html { render :new }
        format.json { render json: @report_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /report_posts/1
  # PATCH/PUT /report_posts/1.json
  def update
    respond_to do |format|
      if @report_post.update(report_post_params)
        format.html { redirect_to report_posts_path, notice: 'ReportPost was successfully updated.' }
        format.json { render :show, status: :ok, location: @report_post }
      else
        format.html { render :edit }
        format.json { render json: @report_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /report_posts/1
  # DELETE /report_posts/1.json
  def destroy
    @report_post.destroy
    respond_to do |format|
      format.html { redirect_to report_posts_url, notice: 'ReportPost was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_report_post
    @report_post = ReportPost.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def report_post_params
    params.require(:report_post).permit(:title, :note, :price, :duration, :time_type, :owner_id, :is_private)
  end

end

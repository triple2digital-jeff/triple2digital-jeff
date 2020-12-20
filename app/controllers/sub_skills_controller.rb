class SubSkillsController < ApplicationController
  before_action :authenticate_user!


  before_action :set_sub_skill, only: [:show, :edit, :update, :destroy]
  layout 'home'
  # GET /sub_skills
  # GET /sub_skills.json
  def index
    @sub_skills = SubSkill.where(search_condition(SubSkill)).page(params[:page])
  end

  # GET /sub_skills/1
  # GET /sub_skills/1.json
  def show
  end

  # GET /sub_skills/new_admin
  def new
    @sub_skill = SubSkill.new
  end

  # GET /sub_skills/1/edit
  def edit
  end

  # POST /sub_skills
  # POST /sub_skills.json
  def create
    @sub_skill = SubSkill.new(sub_skill_params)

    respond_to do |format|
      if @sub_skill.save
        format.html { redirect_to @sub_skill, notice: 'SubSkill was successfully created.' }
        format.json { render :show, status: :created, location: @sub_skill }
      else
        format.html { render :new }
        format.json { render json: @sub_skill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sub_skills/1
  # PATCH/PUT /sub_skills/1.json
  def update
    respond_to do |format|
      if @sub_skill.update(sub_skill_params)
        format.html { redirect_to sub_skills_path, notice: 'SubSkill was successfully updated.' }
        format.json { render :show, status: :ok, location: @sub_skill }
      else
        format.html { render :edit }
        format.json { render json: @sub_skill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sub_skills/1
  # DELETE /sub_skills/1.json
  def destroy
    @sub_skill.destroy
    respond_to do |format|
      format.html { redirect_to sub_skills_url, notice: 'SubSkill was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_sub_skill
    @sub_skill = SubSkill.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sub_skill_params
    params.require(:sub_skill).permit(:title, :skill_id, :description)
  end

end

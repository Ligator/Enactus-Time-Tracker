class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_filter :check_premission
  before_action :set_activity, only: [:show, :edit, :update, :destroy]

  # GET /activities
  # GET /activities.json
  def index
    if current_user.leader?
      @activities = Activity.for_user(current_user).group_by(&:project_id)
      @projects = [current_user.project]
    elsif current_user.admin?
      @activities = Activity.order("id DESC").group_by(&:project_id)
      @projects = Project.select(:id, :name)
    end

    @hours_per_activity = {}
    HourRecord.where(activity_id: @activities.values.flatten.map(&:id)).each do |hour_record|
      @hours_per_activity[hour_record.activity_id] ||= 0
      @hours_per_activity[hour_record.activity_id] += hour_record.worked_hours_dec
    end

    @hours_without_activity = HourRecord.where(activity_id: nil).pluck(:worked_hours_dec).sum
  end

  # GET /activities/1
  # GET /activities/1.json
  def show
  end

  # GET /activities/new
  def new
    @activity = Activity.new
  end

  # GET /activities/1/edit
  def edit
  end

  # POST /activities
  # POST /activities.json
  def create
    @activity = Activity.new(activity_params)

    respond_to do |format|
      if @activity.save
        format.html { redirect_to activities_url, notice: "Actividad creada" }
        format.json { render :show, status: :created, location: @activity }
      else
        format.html { render :new }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activities/1
  # PATCH/PUT /activities/1.json
  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to activities_url, notice: "Actividad actualizada correctamente" }
        format.json { render :show, status: :ok, location: @activity }
      else
        format.html { render :edit }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1
  # DELETE /activities/1.json
  def destroy
    if @activity.hour_records.count > 0
      flash[:error] = "No se pueden eliminar actividades que ya tengan horas registradas."
    else
      @activity.destroy
      respond_to do |format|
        format.html { redirect_to activities_url, notice: "La actividad fue eliminada." }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = Activity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_strong_params
      params.require(:activity).permit(:name, :description)
    end

    def activity_params
      params_hash = activity_strong_params.to_hash.symbolize_keys
      params_hash[:project_id] = current_user.project_id
      params_hash
    end

    def check_premission
      unless current_user.admin? or current_user.leader?
        redirect_to :root
      end
    end
end

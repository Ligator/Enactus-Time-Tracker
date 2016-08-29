class HourRecordsController < ApplicationController
  before_action :check_if_login, only: :index
  before_action :authenticate_user!
  before_action :set_hour_record, only: [:show, :edit, :update, :destroy]

  # GET /hour_records
  # GET /hour_records.json
  def index
    @hour_records = HourRecord.all
  end

  # GET /hour_records/1
  # GET /hour_records/1.json
  def show
  end

  # GET /hour_records/new
  def new
    @hour_record = HourRecord.new
  end

  # GET /hour_records/1/edit
  def edit
  end

  # POST /hour_records
  # POST /hour_records.json
  def create
    @hour_record = HourRecord.new(hour_record_params)

    respond_to do |format|
      if @hour_record.save
        format.html { redirect_to @hour_record, notice: 'Hour record was successfully created.' }
        format.json { render :show, status: :created, location: @hour_record }
      else
        format.html { render :new }
        format.json { render json: @hour_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hour_records/1
  # PATCH/PUT /hour_records/1.json
  def update
    respond_to do |format|
      if @hour_record.update(hour_record_params)
        format.html { redirect_to @hour_record, notice: 'Hour record was successfully updated.' }
        format.json { render :show, status: :ok, location: @hour_record }
      else
        format.html { render :edit }
        format.json { render json: @hour_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hour_records/1
  # DELETE /hour_records/1.json
  def destroy
    @hour_record.destroy
    respond_to do |format|
      format.html { redirect_to hour_records_url, notice: 'Hour record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hour_record
      @hour_record = HourRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hour_record_params
      params.require(:hour_record).permit(:activity_id, :user_id, :worked_hours, :worked_date, :description)
    end

    def check_if_login
      redirect_to new_user_session_path unless user_signed_in?
    end
end

class EnactersController < ApplicationController
  before_filter :check_premission
  before_action :set_enacter, only: [:show, :edit, :update, :destroy]

  def index
    @enacters = User.order(:lname1, :lname2, :fname)
    # @enacters = User.all(order: "lname1, lname2, fname")
  end

  def show
  end

  def send_invitation
    respond_to do |format|
      format.html { redirect_to enacters_url, notice: 'Se ha enviado la invitación al usuario.' }
      format.json { head :no_content }
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @enacter.update(enacter_params)
        format.html { redirect_to enacters_path, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: enacters_path }
      else
        format.html { render :edit }
        format.json { render json: @enacter.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @enacter.destroy
    respond_to do |format|
      format.html { redirect_to enacters_url, notice: 'Se ha eliminado del sistema al Usuario.' }
      format.json { head :no_content }
    end
  end

  private

  def set_enacter
    @enacter = User.find(params[:id])
  end

  def enacter_params
    params
    # params.require(:user).permit(:name, :description, :manager_id)
  end

  def check_premission
    unless (current_user and current_user.admin?) or (current_user and current_user.id == params[:id])
      redirect_to :root
    end
  end
end

class EnactersController < ApplicationController
  before_action :authenticate_user!
  before_filter :check_admin_premission, only: [:invite_enacters, :send_invitation, :destroy]
  before_filter :check_admin_and_leader_premission, only: [:index, :show, :update_positions]
  before_action :set_enacter, only: [:show, :edit, :update, :destroy]

  def index
    if current_user.leader?
      @enacters = User.with_project.
                  where(project_id: current_user.project_id).
                  order(:lname1, :lname2, :fname)

      @free_enacters = User.collaborators.without_project.
                       order(:lname1, :lname2, :fname)

      @users_invited = []
    elsif current_user.admin?
      @enacters = User.with_project.
                  order(:project_id, :lname1, :lname2, :fname)

      @free_enacters = User.without_project.
                       order(:lname1, :lname2, :fname)

      @users_invited = User.unconfirmed.
                       order(:lname1, :lname2, :fname)
    end


    if params[:mode] == "edit" and current_user.admin?
      @edit_mode = true
      @projects = Project.all
      @positions_array = User::POSITIONS.invert.to_a
    end
  end

  def index_for_leaders
  end

  def show
    if current_user.leader? and @enacter.project != current_user.project
      flash[:error] = "Este usuario no pertence a tu proyecto"
      redirect_to enacters_url and return
    end
  end

  def invite_enacters
    @all_emails = params[:email_list]
  end

  def send_invitation
    email_list = params[:email_list]
    @invalid_emails = get_invalid_emails(email_list)

    respond_to do |format|
      if email_list.strip.blank?
        flash[:error] = "Debes introducir al menos una dirección de correo electrónico."
        format.html { redirect_to invite_enacters_path }
        format.json { head :no_content }
      elsif @invalid_emails.any?
        flash[:error] = "Las invitaciones no se enviaron porque hay #{@invalid_emails.size} correos no válidos: #{@invalid_emails.to_sentence}".html_safe
        format.html { redirect_to invite_enacters_path(email_list: email_list) }
        format.json { head :no_content }
      else
        valid_emails = send_invitations_to_all_emails(email_list)
        if valid_emails.blank?
          flash[:error] = "Todos los correos pertenecen a usuarios activos del sistema."
        elsif valid_emails.size == 1
          flash[:notice] = "Se ha enviado la invitación a #{valid_emails.first}. Recargue la página en un momento para ver los cambios."
        else
          flash[:notice] = "Se ha enviado la invitación a #{valid_emails.size} usuarios. Recargue la página en un momento para ver los cambios."
        end
        format.html { redirect_to enacters_url }
        format.json { head :no_content }
      end
    end
  end

  def edit
  end

  def update_positions
    user_attributes = {}
    user_project = params[:project_id] || {}
    user_position = params[:position] || {}

    user_project.each do |user_id, project_id|
      project_id = current_user.project_id if current_user.leader?
      user_attributes[user_id] = { project_id: project_id }
    end

    user_position.each do |user_id, position|
      position = "collaborator" if current_user.leader?
      user_attributes[user_id] ||= {}
      user_attributes[user_id][:position] = position
    end

    user_attributes.each do |user_id, attributes|
      User.find(user_id).update_attributes(attributes)
    end

    respond_to do |format|
      format.html { redirect_to enacters_url, notice: "Se han guardado los cambios." }
      format.json { head :no_content }
    end
  end

  def join_to_my_team

  end

  def update
    respond_to do |format|
      if @enacter.update(enacter_params)
        format.html { redirect_to enacters_path, notice: 'Los datos del usuario se han actualizado correctamente.' }
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

  def get_invalid_emails(email_list)
    require "email_validator"
    invalid_emails = []
    email_list.each_line do |email|
      invalid_emails << email.strip unless EmailValidator.valid?(email)
    end
    invalid_emails
  end

  def send_invitations_to_all_emails(email_list)
    users_email = User.confirmed.where(email: email_list.lines).pluck(:email)
    email_list.each_line do |email|
      next if users_email.include? email
      User.delay.invite!(email: email, position: "collaborator")
    end
    email_list.lines - users_email
  end

  def set_enacter
    @enacter = User.find(params[:id])
  end

  def enacter_params
    params
    # params.require(:user).permit(:name, :description, :manager_id)
  end

  def check_admin_premission
    unless current_user.admin? or (current_user.id == params[:id])
      redirect_to :root
    end
  end

  def check_admin_and_leader_premission
    unless current_user.admin? or current_user.leader? or (current_user.id == params[:id])
      redirect_to :root
    end
  end
end

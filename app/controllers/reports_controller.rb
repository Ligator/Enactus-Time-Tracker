class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_filter :check_admin_and_leader_premission

  def index
    # @exist_user_activities = File.file?(Rails.public_path + "/user_activities_#{Time.current.localtime.strftime('%v')}.xlsx")
  end

  def total_hours
    if params[:date].present?
      date = Date.strptime(params[:date].values.join(","),"%m,%Y")
      @selected_month = params[:date].delete("month").to_i
      @selected_year = params[:date].delete("year").to_i
    else
      date = Time.current
      @selected_month = date.month
      @selected_year = date.year
    end

    @projects = Project.all.to_a
    @projects.unshift(nil)

    @users_hours = {}
    @projects.each do |project|
      @users_hours[project] = User.joins(:hour_records).
                                  where(project_id: project.try(:id), hour_records: { worked_date: date.beginning_of_month..date.end_of_month }).
                                  order([:lname1, :lname2, :fname]).
                                  group([:id, :fname, :lname1, :lname2]).
                                  sum("hour_records.worked_hours_dec")
    end

    @first_year = 2016
    @last_year = Time.current.year

    respond_to do |format|
      format.html
      format.xlsx { render xlsx: :total_hours, filename: "Enacters por Proyecto #{date}" }
    end
  end

  def enacter_details
    @user = User.find(params[:id])
    @hour_records = @user.hour_records.order(worked_date: :desc)
    @hour_records_month = @hour_records.group_by { |hr| hr.worked_date.try(:beginning_of_month) }

    respond_to do |format|
      format.html
      format.xlsx { render xlsx: :enacter_details, filename: "#{@user.full_name} #{Date.today}" }
    end
  end

  private

  def check_admin_and_leader_premission
    unless current_user.admin? or current_user.leader? or (current_user.id == params[:id])
      redirect_to :root
    end
  end
end

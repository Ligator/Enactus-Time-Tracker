class Project < ActiveRecord::Base
  has_many :users
  has_many :activities

  def leaders
    User.where(project_id: id, position: "project_leader")
  end

  def collaborators
    User.where(project_id: id, position: "collaborator")
  end

  def total_hours
  	HourRecord.where(activity_id: activities.pluck(:id)).pluck(:worked_hours).sum
  end
end

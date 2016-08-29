class Project < ActiveRecord::Base
  has_many :users
  has_many :activities

  def leaders
    User.where(project_id: id, position: "project_leader")
  end

  def colaborators
    User.where(project_id: id, position: "colaborator")
  end
end

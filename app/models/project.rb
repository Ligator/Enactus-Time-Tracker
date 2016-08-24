class Project < ActiveRecord::Base
  has_many :activities

  def leader
    User.find(manager_id)
  end

  def colaborators
    User.where(project_id: id)
  end
end

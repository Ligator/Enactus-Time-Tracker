class Activity < ActiveRecord::Base
  belongs_to :project

  scope :for_user, -> (user) { where(project_id: user.project_id) }
end

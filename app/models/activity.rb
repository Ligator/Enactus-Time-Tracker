class Activity < ActiveRecord::Base
  belongs_to :project
  has_many :hour_records

  scope :for_user, -> (user) { where(project_id: user.project_id) }
end

class HourRecord < ActiveRecord::Base
  belongs_to :activity
  belongs_to :user

  scope :for_user,         -> (user) { where(user_id: user.id).order(worked_date: :desc) }
  scope :without_activity, -> { where(activity_id: nil) }
  scope :with_activity,    -> { where("activity_id IS NOT NULL") }

  validates :worked_hours_dec, presence: true, numericality: true

  def project
    if activity_id
      activity.project.presence
    else
      nil
    end
  end
end

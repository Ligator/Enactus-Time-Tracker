class HourRecord < ActiveRecord::Base
  belongs_to :activity
  belongs_to :user

  scope :for_user,         -> (user) { where(user_id: user.id) }
  scope :without_activity, -> { where(activity_id: nil) }
  scope :with_activity,    -> { where("activity_id IS NOT NULL") }
end

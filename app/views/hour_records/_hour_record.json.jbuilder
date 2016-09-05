json.extract! hour_record, :id, :activity_id, :user_id, :worked_hours_dec, :worked_date, :description, :created_at, :updated_at
json.url hour_record_url(hour_record, format: :json)
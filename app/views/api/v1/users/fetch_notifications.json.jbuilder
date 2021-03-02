json.array!(@notifications) do |notify|
  json.id notify.id
  json.content notify.description
  if notify.notification_type == "endorsement"
    json.event_type notify.notification_type
    json.object_id notify.notifier_id
  elsif notify.notification_type == "unendorsement"
    json.event_type notify.notification_type
    json.object_id notify.notifier_id
  elsif notify.notification_type == "appointment"
    json.event_type notify.notification_type
    appointment = Appointment.find_by(id: notify.object_id)
    json.object_id appointment.service_id
  elsif notify.notification_type == "appointment_update"
    json.event_type notify.notification_type
    appointment = Appointment.find_by(id: notify.object_id)
    json.object_id appointment.service_id
  elsif notify.notification_type == "appointment_cancel"
    json.event_type notify.notification_type
    appointment = Appointment.find_by(id: notify.object_id)
    json.object_id appointment.service_id
  elsif notify.notification_type == "comment"
    json.event_type notify.notification_type
    json.object_id notify.object_id
  elsif notify.notification_type == "like_post"
    json.event_type notify.notification_type
    json.object_id notify.object_id
  elsif notify.notification_type == "shared_post"
    json.event_type notify.notification_type
    json.object_id notify.object_id
  elsif notify.notification_type == "user_connection"
    json.event_type notify.notification_type
    json.object_id notify.notifier_id
  elsif notify.notification_type == "left_review"
    json.event_type notify.notification_type
    review = Review.find_by(id: notify.object_id)
    json.object_id review.reviewable_id if review.reviewable_type=="Event"
  elsif notify.notification_type == "purchased_ticket"
    json.event_type notify.notification_type
    json.object_id notify.object_id
  elsif notify.notification_type == "event_create"
    json.event_type notify.notification_type
    json.object_id notify.object_id
  elsif notify.notification_type == "event_change"
    json.event_type notify.notification_type
    json.object_id notify.object_id
  end
  json.created_at notify.created_at 
end
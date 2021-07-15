json.array!(@notifications) do |notify|
  json.id notify.id
  json.content notify.description
  if notify.notification_type == "endorsement"
    json.event_type notify.notification_type
    json.object_id notify.notifier_id
    user = User.find_by(id: notify.notifier_id)
    json.profile_url user.present? ? user.profile_img : nil
    if user.present?
      json.is_endorsed user.endorsements.where(endorsed_by_id: notify.user_id).first.present?
    else
      json.is_endorsed nil
    end
  elsif notify.notification_type == "unendorsement"
    json.event_type notify.notification_type
    json.object_id notify.notifier_id
    user = User.find_by(id: notify.notifier_id)
    json.profile_url user.present? ? user.profile_img : nil
    json.is_endorsed user.endorsements.where(endorsed_by_id: notify.user_id).first.present?
  elsif (notify.notification_type == "appointment") && Appointment.find_by(id: notify.object_id)
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
    user = User.find_by(id: notify.notifier_id)
    json.profile_url user.present? ? user.profile_img : nil
    user_con = User.find_by(id: notify.user_id)
    if user_con.present?
      json.is_link_sent user_con.user_connections.where(connection_id: notify.notifier_id).first.present?
    else
      json.is_link_sent nil
    end
  elsif notify.notification_type == "left_review"
    json.event_type notify.notification_type
    review = Review.find_by(id: notify.object_id)
    if review.present? && review.reviewable_type=="Event"
      json.object_id review.reviewable_id 
    else
      json.object_id nil
    end
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
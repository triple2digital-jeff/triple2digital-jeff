json.array!(@notifications) do |notify|
  json.id notify.id
  json.content notify.description
  json.event_type notify.notification_type
  json.object_id notify.object_id
  json.created_at notify.created_at 
end
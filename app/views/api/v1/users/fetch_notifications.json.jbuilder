json.array!(@notifications) do |notify|
  json.content notify.description
end
json.voucher do
  json.id @voucher.id
  json.voucher_id @voucher.voucher_id
  json.code @voucher.code
  json.type @voucher.vc_type
  json.category @voucher.category
  json.discount @voucher.discount
  json.active @voucher.active
  json.description @voucher.description
end
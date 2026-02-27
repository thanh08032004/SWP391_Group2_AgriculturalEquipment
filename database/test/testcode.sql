select * from voucher v
where v.is_active = true
and curdate() between v.start_date and v.end_date
and v.code like '%SAVe50K%';
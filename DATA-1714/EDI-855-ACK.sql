select 
    entity.name                             as vendor
    ,po.tranid                              as po_number
    ,lines.transaction_line_id              as line_id
    ,po.transaction_id   
    ,lines.acknowledgment_item_status_id 	
    ,status.list_item_name                  as acknowledgment_item_status
    ,lines.acknowledgment_rate		
    ,lines.acknowledgment_scheduled_date		
    ,lines.acknowledgment_scheduled_quan    as acknowledgment_scheduled_quantity
    ,lines.acknowledgment_memo
    ,lines.n_2nd_acknowledgment_item_s_id	
    ,status_2nd.list_item_name              as _2nd_acknowledgment_item_status		
    ,lines.n_2nd_acknowledgment_scheduled
    ,lines.n_2nd_acknowledgment_schedul_0   as _2nd_acknowledgment_scheduled_quantity
from 
  ns_transactions.transactions po
inner join 
  ns_transaction_lines.transaction_lines lines ON po.transaction_id=lines.transaction_id
left join 
  ns_entity.entity entity ON cast(po.entity_id as int64) = cast(entity.entity_id as int64)
left join
  fivetran_transaction_lines_temp.acknowledgment_item_statuses status ON lines.acknowledgment_item_status_id = status.list_id
left join
  fivetran_transaction_lines_temp.acknowledgment_item_statuses status_2nd ON lines.n_2nd_acknowledgment_item_s_id = status_2nd.list_id
where  lines.transaction_line_id > 0
----------------- Edit the PO number
--and po.tranid='12187348286'
-----------------
order by lines.transaction_line_id asc
limit 100
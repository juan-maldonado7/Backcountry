select 
	 entity.name 						as vendor
	,brand.brand_name					as brand
	,po.create_date 					as po_date
	,po.trandate  						as po_date2
	,po.ship_date 
	,po.original_ship_date 				as __original_ship_date
	,po.cancel_date 
	,po.original_cancel_date 			as __original_cancel_date
	,po.tranid 							as po_number
	,merch.merchandise_division_name	as merchandise_division
	,type.list_item_name 				as po_type
	,season.list_item_name 				as season_code
	,year.list_item_name 				as season_year
	,employ .full_name					as buyer 
	,lines.transaction_line_id			as line_id
	,item.item_extid 					as sku 
	,lines.vendor_sku	
	,item.upc_code 						as upc 
	,lines.memo
	,lines.expected_arrival_eta_line						
	,lines.item_count 					as quantity_in_transaction_unit
	,lines.original_transmitted_qty
	,'------'							as quantity_fulfilled_received
	,lines.quantity_received_in_shipment
	,lines.number_billed 				as quantity_billed
	,'------'							as qty_in_transit
	,uom.name							as units
	,lines.acknowledgment_rate			as rate1__
	,lines.item_unit_price 				as rate2__
	,lines.discount_amount 
	,lines.purchase_price 
	,lines.amount 
	,lines.asn_record 
	,lines.asn_quantity_shipped 
	,lines.asn_shipment_date 
	,lines.asn_estimated_delivery_date 
	,po.n_860_last_execution_timestamp 	as _860_sent
	,po.status 
	,'------'							as in_tansit_windows
	,'------'							as transit_window_edn
,po.transaction_id , po.entity_id, po.external_id, po.sales_rep_id, po.tranid, po.po_batch_name, po.transaction_extid, po.transaction_number  
from 
	ns_transactions.transactions po
left join
	ns_transaction_lines.transaction_lines lines ON cast(po.transaction_id as int64) = cast(lines.transaction_id as int64)
left join
	netsuite_sc.season season ON cast(po.season_code_id as int64) = cast(season.list_id as int64)
left join 
	netsuite_sc.year1 year ON cast(po.season_year_id as int64) = cast(year.list_id as int64)
left join 
	netsuite_sc.po_types type ON cast(po.po_type_id as int64) = cast(type.list_id as int64)
left join 
	ns_entity.entity entity ON cast(po.entity_id as int64) = cast(entity.entity_id as int64)
left join 
	netsuite2.brand brand ON cast(brand.brand_id as int64) = cast(lines.brand_id as int64)
left join 
	ns_sb1.merchandise_division merch ON cast(merch.merchandise_division_id as int64) = cast(po.merchandise_division_id as int64)
left join  
	netsuite2.employees employ ON cast(po.sales_rep_id as int64) = cast(employ.employee_id as int64)
left join 
	netsuite.items_cv item ON cast(lines.item_id as int64) = cast(item.item_id as int64)
left join
	netsuite_sc.uom uom ON cast(item.uom_id as int64) = cast(uom.uom_id as int64)
where po.create_date > '2021-05-01' and po.transaction_type ='Purchase Order'
--and po.tranid in ('12186207557') and  lines.transaction_line_id=20
and po.tranid in ('12229298372') --and  lines.transaction_line_id=8
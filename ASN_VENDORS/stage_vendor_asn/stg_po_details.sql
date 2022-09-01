create or replace table elcap_stg_dev.stg_purchase_orders_details as
select 
   po.tranid as po_number
  --,item.name  as item_name
  ,item.item_extid                --as sku
  ,lines.vendor_sku               --as vendor_sku
  ,item.salesdescription   as item_description
  ,ifnull(lines.expected_arrival_eta_line,(CAST('1900-01-01' AS TIMESTAMP))) as expected_arrival_eta_line
  ,period_closed as closed
  ,lines.item_count               --as quantity
  ,lines.original_transmitted_qty 
  ,lines.quantity_received_in_shipment --as received
  ,lines.number_billed            --as billed
  ,uom.name AS unit_of_measure
  ,lines.item_unit_price          --as rate
  ,REGEXP_REPLACE(lines.item_unit_price, r'\%|-', '')  AS rate --------
  ,lines.purchase_price
  ,lines.discount_amount          --||'%' as discount_amount
  ,lines.amount
  ,pgroup.product_group_name
  ,item.upc_code                          --as upc 
  ,brand.brand_name 
  ,'' as options
  ,lines.line_created_date
  ,lines.quantity_available
  ,ack_status.list_item_name    as acknowledgment_item_status
  ,lines.transaction_line_id
  ,case 
          when inv.sku is null then false
          else true
  end  AS inventory_owned_flag
  ,current_timestamp() as transaction_expected_arrival_date
  ,lines.acknowledgment_rate
  ,lines.acknowledgment_scheduled_date
  ,lines.acknowledgment_scheduled_quan
  ,lines.acknowledgment_memo
  ,n2_ack_status.list_item_name as n_2nd_acknowledgment_item_status
  ,lines.n_2nd_acknowledgment_scheduled as n_2nd_acknowledgment_scheduled_date
  ,lines.n_2nd_acknowledgment_schedul_0 as n_2nd_n_2nd_acknowledgment_schedul_quan
  ,lines.asn_record
  ,lines.asn_quantity_shipped
  ,lines.asn_shipment_date
  ,lines.asn_estimated_delivery_date
  -----Javier Columns
  ,lines.demand_amount
  ,lines.demand_cogs
  ,lines.demand_quantity
  ,lines.estimated_cost
  ,lines.full_price
  ,lines.shipping_amount
  ,lines.amount_custom
  ,lines.amount_foreign
  ,lines.amount_pending
  ,lines.original_cogs
  ,lines.po__rate
  ,lines.quantity_allocated
  ,lines.quantity_custom
  ,lines.quantity_difference
  ,lines.quantity_on_order
  ,lines.rate_custom
from
  ns_transactions.transactions po
INNER JOIN 
  ns_transaction_lines.transaction_lines lines ON lines.transaction_id = po.transaction_id
LEFT JOIN 
  ns_items.items_cv item ON  cast(lines.item_id as int64) = cast(item.item_id as int64)
LEFT JOIN 
  (
        SELECT distinct sku FROM elcap.sb_inventory
        WHERE snapshot_day = timestamp_sub(TIMESTAMP_TRUNC(CURRENT_TIMESTAMP, DAY, 'America/Denver'), interval 1 day) 
  ) inv ON inv.sku = item.item_extid
LEFT JOIN 
  netsuite_sc.uom uom ON cast(lines.unit_of_measure_id as int64) = cast(uom.uom_id as int64)
left join
  netsuite2.brand brand ON cast(brand.brand_id as int64) = cast(lines.brand_id as int64)
left join 
  netsuite_vendor_asn.acknowledgment_item_statuses ack_status on ack_status.list_id=lines.acknowledgment_item_status_id
left join 
  netsuite_vendor_asn.acknowledgment_item_statuses n2_ack_status on n2_ack_status.list_id=lines.n_2nd_acknowledgment_item_s_id
left join 
  netsuite2.product_group pgroup ON pgroup.product_group_id=lines.product_group_id
WHERE
    po.tranid IS NOT NULL and po.transaction_type = 'Purchase Order'
    and lines.transaction_line_id >= 1
    --and  po.tranid='12240899573'
order by lines.transaction_line_id asc

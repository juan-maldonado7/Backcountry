select 
    vendor.name
    ---Primary information
    ,vendor.companyname
    ,case when vendor.isinactive = 'No' then 'Active'
            else 'Inactive'
    end                 as status
    ,vendor.name        as vendor_id
    ,vendor.vendor_id          as internal_vendor_id
    ,case when vendor.is_person = 'No' then 'Company'
            else 'Individual'
    end                 as type
    ,vtype.name         as vendor_category
    ,pterms.name        as terms
    ,vendor.incoterm
    ,vendor.comments
    ---Email, phone, address
    ,vendor.email
    ,vendor.email_address_for_payment_not
    ,vendor.accounting_email
    ,vendor.phone
    ,vendor.altphone
    ,vendor.fax
    ,vendor.url         as web_address
    ,vendor.billaddress as address
    -----Address Tab
    ,ARRAY_AGG(
        struct(address.is_default_bill_address
                ,address.is_default_ship_address
                ,address.name   as label
                ,address.address
                ,address.is_inactive
                )
    )  as address_tab
    ----Purchasing Tab
    ,vendor.edi
    ,vendor.edi_855_activation_date
    ,vendor.edi_850_id
    ,vendor.edi_860_id
    ,vendor.edi_855_id
    ,vendor.edi_856_id
    ,vendor.edi_810_id
    ,vendor.edi_846_id
    ,vendor.edi_capable
    ,vendor.creditlimit
    ,vendor.vendor_credit_limit_date
    ,currency.name as currency
    ----Aprovals
    ,vendor.create_date as created_date
    ,vendor.created_by_ven_id
    ,employee.full_name
    ,vendor.finance_status_ven_id
    ,vendor.operations_status_ven_id
    -------subsidiary
    ,vendor.subsidiary
    ,sub.name  as primary_subsidiary
    ------details
      ,ARRAY_AGG( 
          struct( ven_sub.name as subsidiary
                  ,case when vs_map.subsidiary_id = vendor.subsidiary then True
                        else False
                  end as primary
                  ,ven_sub.isinactive
                  ,vs_map.balance
                  ,vs_map.balance_base
                  ,vs_map.unbilled_orders
                  ,vs_map.unbilled_orders_base
                  ,vs_map.credit_limit
                  ,vs_map.subsidiary_id
                  )
      )  as subsidiary_details
    ----Financials
    ,vs_map.balance
    ,vs_map.unbilled_orders
    ,currency.name as currency
    ---Relationships
    ---Comunications
from 
  netsuite2.vendors vendor 
left join 
  netsuite_sc.vendor_types vtype ON vendor.vendor_type_id = vtype.vendor_type_id
left join
  netsuite_sc.payment_terms pterms ON vendor.payment_terms_id = pterms.payment_terms_id
left join
  netsuite2.address_book address ON vendor.vendor_id=address.entity_id
left join
  netsuite_sc.currencies currency ON vendor.currency_id = currency.currency_id
left join  
	netsuite2.employees employee ON cast(vendor.created_by_ven_id as int64) = cast(employee.employee_id as int64)
left join
  netsuite_sc.subsidiaries sub ON vendor.subsidiary=sub.subsidiary_id
left join
  netsuite_vendor_asn.vendor_subsidiary_map vs_map ON  vs_map.vendor_id=vendor.vendor_id
left join 
  netsuite_sc.subsidiaries ven_sub ON ven_sub.subsidiary_id=sub.subsidiary_id
where companyname is not null 
--------Edit the VENDOR_ID
and companyname='Adidas'
----------------------------
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18
,20,21,22,23,24,25,26,27,28,29,30,31
,32,33,34,35,36,37,38
,40,41
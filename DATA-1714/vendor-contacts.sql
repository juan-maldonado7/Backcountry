select 
    vendor.name
    ---Primary information
    ,vendor.companyname
    ,case when vendor.isinactive = 'No' then 'Active'
            else 'Inactive'
    end                 as status
    ,vendor.name        as vendor_id
    ,vendor_id          as internal_vendor_id
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
    -----Address
    ,ARRAY_AGG(
        struct(address.is_default_bill_address
                ,address.is_default_ship_address
                ,address.name   as label
                ,address.address
                ,address.is_inactive
                )
    )  as address_tab
from 
  netsuite2.vendors vendor 
left join 
  netsuite_sc.vendor_types vtype ON vendor.vendor_type_id = vtype.vendor_type_id
left join
  netsuite_sc.payment_terms pterms ON vendor.payment_terms_id = pterms.payment_terms_id
left join
  netsuite2.address_book address ON vendor.vendor_id=address.entity_id
where companyname is not null 
--------Edit the VENDOR_ID
and companyname='Adidas'
----------------------------
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18
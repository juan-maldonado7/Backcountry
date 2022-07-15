select 
  contacts.contact_id
  ,contacts.full_name
  ----primary information
  ,contacts.name                                    as contact
  ,contacts.salutation                              as salutation_MR_MS
  ,contacts.firstname || ' ' || contacts.lastname   as name
  ,contacts.company_id
  ,companies.companyname                            as company
  ,contacts.title                                   as job_title
  ,contacts.comments
  ,contacts.is_private                              as private
  ,ARRAY_AGG(
    coalesce(contact_types.name,'')
  )                                                 as category
  ----Email | Phone | Address
  ,contacts.email
  ,contacts.altemail
  ,contacts.phone                                   as mainphone
  ,contacts.officephone
  ,contacts.mobilephone
  ,contacts.homephone
  ,contacts.fax 
  ,contacts.address
  ----Classification
  ,contacts.subsidiary                              as subsidiary_id
  ,sub.name                                         as subsidiary
  ,contacts.last_sales_activity
  ----Relationships
  ,sup.name                                         as supervisor
  ,contacts.supervisorphone
  ,assist.name                                      as assistand
  ,contacts.assistantphone
  ----Address
  ,address.is_default_ship_address
  ,address.is_default_bill_address
  ,address.address
  ,contacts.isinactive
from 
  netsuite_vendor_asn.contacts 
left join 
  netsuite2.address_book address ON address.entity_id=contacts.contact_id
left join
  netsuite_sc.subsidiaries sub ON sub.subsidiary_id=contacts.subsidiary
left join
  netsuite_sc.companies ON companies.company_id=contacts.company_id
left join
  ns_entity.entity sup ON sup.entity_id=contacts.supervisior_id
left join
  ns_entity.entity assist ON assist.entity_id=contacts.assistant_id
left join
  netsuite_vendor_asn.contact_types ON contact_types.contact_id=contacts.contact_id 
group by 1,2,3,4,5,6,7,8,9,10
,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30

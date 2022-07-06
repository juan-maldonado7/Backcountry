select 
  contacts.contact_id
  ,contacts.full_name
  ----primary information
  ,contacts.name        as contact
  ,contacts.salutation  as salutation_MR_MS
  ,contacts.firstname || ' ' || contacts.lastname as name
  ,contacts.company_id
  ,companies.companyname     as company
  ,contacts.title       as job_title
  ,contacts.comments
  ,contacts.is_private  as private
  ,'---'                as category
  ----Email | Phone | Address
  ,contacts.email
  ,contacts.altemail
  ,contacts.phone       as mainphone
  ,contacts.officephone
  ,contacts.mobilephone
  ,contacts.homephone
  ,contacts.fax 
  ,contacts.address
  ----Classification
  ,contacts.subsidiary    as subsidiary_id
  ,sub.name               as subsidiary
  ,contacts.last_sales_activity
  ----Relationships
  ,contacts.supervisior_id
  ,contacts.supervisorphone
  ,contacts.assistant_id
  ,contacts.assistantphone
  ----Address
  ,address.is_default_ship_address
  ,address.is_default_bill_address
  ,address.address
  ,contacts.isinactive
  ,contacts.* 
from 
  netsuite_vendor_asn.contacts 
left join 
  netsuite2.address_book address ON address.entity_id=contacts.contact_id
left join
  netsuite_sc.subsidiaries sub ON sub.subsidiary_id=contacts.subsidiary
left join
  netsuite_sc.companies ON companies.company_id=contacts.company_id
where 
--contacts.email='kort.sonnentag@adidas.com'
--contacts.email='VendorOps@backcountry.com'
contacts.email='shawn.hillman@deckers.com'

--select * from netsuite_vendor_asn.contact_types where contact_id=37942695


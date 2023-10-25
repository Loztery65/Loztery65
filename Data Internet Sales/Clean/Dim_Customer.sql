SELECT 
  b.CustomerKey,
  b.CustomerAlternateKey, 
  b.FirstName, 
  b.LastName, 
  concat(b.FirstName, ' ', b.LastName) as FullName, 
  case b.gender when 'M' then 'Male' when 'F' then 'Female' end as Gender, 
  b.DateFirstPurchase, 
  c.City as Customer_City 
FROM 
  [AdventureWorksDW2019].[dbo].[DimCustomer] as b 
  left join [dbo].[DimGeography] as c on b.GeographyKey = c.GeographyKey 
order by 
  b.CustomerKey asc

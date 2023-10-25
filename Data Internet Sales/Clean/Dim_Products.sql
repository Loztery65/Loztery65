SELECT 
  p.ProductKey, 
  p.ProductAlternateKey, 
  p.EnglishProductName as Name_Product, 
  ps.EnglishProductSubcategoryName as Name_Sub_Product, 
  pc.EnglishProductCategoryName as Product_Cat, 
  p.Color, 
  p.Size, 
  p.ProductLine, 
  p.ModelName, 
  p.EnglishDescription as Product_Desc, 
  ISNULL (p.Status, 'Outdated') as Product_Stat 
FROM 
  [AdventureWorksDW2019].[dbo].[DimProduct] as p 
  left join [dbo].[DimProductSubcategory] as ps on p.ProductSubcategoryKey = ps.ProductSubcategoryKey 
  left join [dbo].[DimProductCategory] as pc on ps.ProductCategoryKey = pc.ProductCategoryKey 
order by 
  p.ProductKey asc

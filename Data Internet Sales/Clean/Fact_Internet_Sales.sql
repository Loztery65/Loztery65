SELECT 
  Ins.ProductKey, 
  Ins.OrderDateKey, 
  Ins.DueDateKey, 
  Ins.ShipDateKey, 
  Ins.CustomerKey, 
  Ins.SalesOrderNumber, 
  Ins.SalesAmount 
FROM 
  [AdventureWorksDW2019].[dbo].[FactInternetSales] as Ins 
where 
  left(Ins.OrderDateKey, 4) >= YEAR(getdate()) -2
order by 
  Ins.OrderDateKey asc

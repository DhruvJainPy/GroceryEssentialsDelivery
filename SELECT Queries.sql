SET SEARCH_PATH TO SQL_PROJECT2;

-- For General Customers 
-- 1. Search for Products based on various parameters/filters.
	-- a) Filter by Price
	SELECT 
	    ProdID, 
	    ProdName, 
	    Brand, 
	    Price, 
	    Size
	FROM 
	    Products
	WHERE 
	    Price BETWEEN 500 AND 1500;
	
	-- b) Filter by Brand
	SELECT 
	    ProdID, 
	    ProdName, 
	    Brand, 
	    Price, 
	    Size
	FROM 
	    Products
	WHERE 
	    Brand = 'Licious';
	
	-- c) Filter by SubCategory and Category
	SELECT 
	    ProdID, 
	    ProdName, 
	    Brand, 
	    Price, 
	    CatName AS Category, 
	    SubName AS SubCategory
	FROM 
	    Products 
	JOIN 
	    SubCategories ON Products.SubCategoryID = SubCategories.SubCategoryID
	JOIN 
	    Categories ON SubCategories.CategoryID = Categories.CategoryID
	WHERE 
	    CatName = 'Pet Care' 
	    AND SubName = 'Pet Grooming & Accessories'; 
	
	-- d) Filter by Availability
	SELECT 
	    Products.ProdID, 
	    ProdName, 
	    Brand, 
	    Price 
	FROM 
	    Products 
	JOIN 
	    Inventory ON Products.ProdID = Inventory.ProdID
	WHERE 
	    Quantity > 0; 


-- 2. Details about customer’s orders.
	-- a) Customer Order History
	SELECT 
	    o.OrderID, 
	    o.OrderDate, 
	    p.ProdName, 
	    od.Quantity, 
	    od.Price, 
	    (od.Quantity * od.Price) AS TotalPrice, 
	    o.Status
	FROM 
	    Orders o
	JOIN 
	    OrderDetails od ON o.OrderID = od.OrderID
	JOIN 
	    Products p ON od.ProdID = p.ProdID
	WHERE 
	    o.CustID = '7feb66e536';
	
	-- b) Detailed Order Information (Delivery Address)
	SELECT 
	    o.OrderID, 
	    c.CustName, 
	    ca.FlatNo, 
	    ca.Landmark, 
	    ca.Pincode, 
	    o.Amount, 
	    o.OrderDate, 
	    o.Status
	FROM 
	    Orders o
	JOIN 
	    Customers c ON o.CustID = c.CustID
	JOIN 
	    CustAddress ca ON o.AddressID = ca.AddressID;

-- 3. Display the items in their cart.
SELECT 
    c.CustID, 
	CustName,
    cd.CartID, 
    p.ProdName, 
    p.Brand, 
    p.Price, 
    cd.Quantity, 
    cd.Sub_Total
FROM 
    Cart c
JOIN 
    CartDetails cd ON c.CartID = cd.CartID
JOIN 
    Products p ON cd.ProdID = p.ProdID
NATURAL JOIN 
	Customers
WHERE 
    c.CustID = '01ba15562f'; 


-- For Warehouses 
-- 1. Manage Inventory of items.
	-- a) View Current Stock
	SELECT 
	    i.InventoryID, 
	    p.ProdName, 
	    p.Brand, 
	    i.Quantity AS CurrentStock, 
	    i.Min_Quantity AS MinStock,
	    w.Name AS WarehouseName
	FROM 
	    Inventory i
	JOIN 
	    Products p ON i.ProdID = p.ProdID
	JOIN 
	    Warehouses w ON i.WarehouseID = w.WarehouseID
	WHERE
		w.WarehouseID = '1841543963'
	ORDER BY 
	    i.Quantity DESC; 
	
	-- b) Fetch Products below the Reorder level
	SELECT 
	    i.InventoryID, 
	    p.ProdName, 
	    p.Brand, 
	    i.Quantity AS CurrentStock, 
	    i.Min_Quantity AS ReorderLevel,
	    (i.Min_Quantity - i.Quantity) AS ReorderQuantity
	FROM 
	    Inventory i
	JOIN 
	    Products p ON i.ProdID = p.ProdID
	JOIN 
	    Warehouses w ON i.WarehouseID = w.WarehouseID
	WHERE
		w.WarehouseID = '1841543963' AND
	    i.Quantity < i.Min_Quantity
	ORDER BY 
	    i.Quantity ASC;
	
	-- c) Retrieve Suppliers Information for existing products in the Warehouse
	SELECT 
	    w.WarehouseID, 
	    w.Name AS WarehouseName, 
	    w.Location, 
	    p.ProdID, 
	    p.ProdName, 
	    p.Brand, 
	    s.SupplierID, 
	    s.Name AS SupplierName, 
	    so.SupplyDate, 
	    sod.Quantity AS SuppliedQuantity,
		sod.Price AS SuppliedPrice
	FROM 
	    Warehouses w
	JOIN 
	    Inventory i ON w.WarehouseID = i.WarehouseID
	JOIN 
		SupplyOrderDetails sod ON sod.ProdID = i.ProdID
	JOIN 
		SupplyOrders so ON so.SupplyOrderID = sod.SupplyOrderID
	JOIN 
	    Products p ON p.ProdID = i.ProdID
	JOIN 
	    Suppliers s ON so.SupplierID = s.SupplierID
	WHERE
		w.WarehouseID = '1841543963'
	ORDER BY 
	    w.Name, p.ProdName, s.Name;
	
	-- d) Retrieve Suppliers Information for all products
	SELECT 
	   	p.ProdID, 
	    p.ProdName, 
	    p.Brand, 
	    s.SupplierID, 
	    s.Name AS SupplierName, 
	    so.SupplyDate, 
	    sod.Quantity AS SuppliedQuantity,
		sod.Price AS SuppliedPrice,
		c.City AS City,
		c.State AS State
	FROM
		Inventory i 
	JOIN 
		SupplyOrderDetails sod ON sod.ProdID = i.ProdID
	JOIN 
		SupplyOrders so ON so.SupplyOrderID = sod.SupplyOrderID
	JOIN 
	    Products p ON p.ProdID = i.ProdID
	JOIN 
	    Suppliers s ON so.SupplierID = s.SupplierID
	JOIN 
		Cities c ON c.Pincode = s.pincode
	ORDER BY 
	    p.ProdName, s.Name;

-- 2. Most (Least) Ordered/Rated Products.
	-- a) Overall Most Ordered Products
	SELECT 
	    p.ProdID, 
	    p.ProdName, 
	    SUM(od.Quantity) AS TotalOrdered,
		p.Description
	FROM 
	    Orders o
	JOIN 
	    OrderDetails od ON o.OrderID = od.OrderID
	JOIN 
	    CustAddress ca ON o.AddressID = ca.AddressID
	JOIN 
		Cities c ON c.Pincode = ca.Pincode
	JOIN 
	    Products p ON od.ProdID = p.ProdID
	GROUP BY 
	    p.ProdID, p.ProdName,p.Description
	ORDER BY 
	    TotalOrdered DESC; 
	
	-- b) Overall Most Ordered Products based on the Warehouse city
	SELECT 
	    p.ProdID, 
	    p.ProdName, 
	    SUM(od.Quantity) AS TotalOrdered, 
	    w.WarehouseID, 
	    w.Name AS WarehouseName, 
	    ca.Pincode
	FROM 
	    Orders o
	JOIN 
	    OrderDetails od ON o.OrderID = od.OrderID
	JOIN 
	    CustAddress ca ON o.AddressID = ca.AddressID
	JOIN 
		Cities c ON c.Pincode = ca.Pincode
	JOIN
	    Inventory i ON od.ProdID = i.ProdID
	JOIN 
	    Warehouses w ON i.WarehouseID = w.WarehouseID
	JOIN 
	    Products p ON od.ProdID = p.ProdID
	WHERE 
	    w.WarehouseID = '1841543963'
	GROUP BY 
	    p.ProdID, p.ProdName, w.WarehouseID, w.Name, ca.Pincode
	ORDER BY 
	    TotalOrdered DESC; 
	
	-- c) Category-Wise Most Ordered Items
	SELECT 
	    c.CategoryID, 
	    c.CatName, 
		sc.SubCategoryID,
		sc.SubName,
	    p.ProdID, 
	    p.ProdName, 
	    SUM(od.Quantity) AS TotalOrdered
	FROM 
	    OrderDetails od
	JOIN 
	    Products p ON od.ProdID = p.ProdID
	JOIN 
	    SubCategories sc ON p.SubCategoryID = sc.SubCategoryID
	JOIN 
		Categories c ON c.CategoryID = sc.CategoryID
	GROUP BY 
	    c.CategoryID,sc.SubCategoryID,sc.SubName,c.CatName, p.ProdID, p.ProdName
	ORDER BY 
	    c.CatName ASC, TotalOrdered DESC; 

-- 3) Orders cancelled by Customers.
SELECT 
    o.OrderID,
	c.CustName,
	COUNT(o.OrderID) AS TotalCancelledOrders
FROM 
    Orders o
JOIN 
    Customers c ON c.CustID = o.CustID
WHERE
    o.Status = 'Cancelled'
GROUP BY
	o.OrderID,c.CustName;


-- For HelpDesk Agents 
--1. Total number of complaints received in a day/week/month/year. 
	-- a) Daily
	SELECT
		DATE(o.OrderDate) AS ComplaintDate,
		COUNT(*) AS TotalComplaints
	FROM 
	    Orders o
	JOIN 
	    Complaints c ON c.OrderID = o.OrderID
	GROUP BY DATE(o.OrderDate)
	ORDER BY ComplaintDate;
	
	-- b) Weekly
	SELECT
	    DATE_TRUNC('week', o.OrderDate) AS WeekStartDate,
	    COUNT(*) AS TotalComplaints
	FROM 
	    Orders o
	JOIN 
	    Complaints c ON c.OrderID = o.OrderID
	GROUP BY DATE_TRUNC('week', o.OrderDate)
	ORDER BY WeekStartDate;
	
	-- c) Monthly
	SELECT
	    DATE_TRUNC('month', o.OrderDate) AS Month,
	    COUNT(*) AS TotalComplaints
	FROM 
	    Orders o
	JOIN 
	    Complaints c ON c.OrderID = o.OrderID
	GROUP BY DATE_TRUNC('month', o.OrderDate)
	ORDER BY Month;
	
	-- d) Yearly
	SELECT
	    DATE_TRUNC('year', o.OrderDate) AS Year,
	    COUNT(*) AS TotalComplaints
	FROM 
	    Orders o
	JOIN 
	    Complaints c ON c.OrderID = o.OrderID
	GROUP BY DATE_TRUNC('year', o.OrderDate)
	ORDER BY Year;

-- 2. Total number of complaints handled in a day/week/month/year. 
	-- a) Daily
	SELECT
		DATE(o.OrderDate) AS ComplaintDate,
		COUNT(*) AS TotalComplaints
	FROM 
	    Orders o
	JOIN 
	    Complaints c ON c.OrderID = o.OrderID
	JOIN 
		HelpAgents ha ON ha.HelpAgentID = c.HelpAgentID
	WHERE 
		ha.HelpAgentID = '1124987276'
	GROUP BY DATE(o.OrderDate)
	ORDER BY ComplaintDate;
	
	-- b) Weekly
	SELECT
	    DATE_TRUNC('week', o.OrderDate) AS WeekStartDate,
	    COUNT(*) AS TotalComplaints
	FROM 
	    Orders o
	JOIN 
	    Complaints c ON c.OrderID = o.OrderID
	JOIN 
		HelpAgents ha ON ha.HelpAgentID = c.HelpAgentID
	WHERE 
		ha.HelpAgentID = '1124987276'
	GROUP BY DATE_TRUNC('week', o.OrderDate)
	ORDER BY WeekStartDate;
	
	-- c) Monthly
	SELECT
	    DATE_TRUNC('month', o.OrderDate) AS Month,
	    COUNT(*) AS TotalComplaints
	FROM 
	    Orders o
	JOIN 
	    Complaints c ON c.OrderID = o.OrderID
	JOIN 
		HelpAgents ha ON ha.HelpAgentID = c.HelpAgentID
	WHERE 
		ha.HelpAgentID = '1124987276'
	GROUP BY DATE_TRUNC('month', o.OrderDate)
	ORDER BY Month;
	
	-- d) Yearly
	SELECT
	    DATE_TRUNC('year', o.OrderDate) AS Year,
	    COUNT(*) AS TotalComplaints
	FROM 
	    Orders o
	JOIN 
	    Complaints c ON c.OrderID = o.OrderID
	JOIN 
		HelpAgents ha ON ha.HelpAgentID = c.HelpAgentID
	WHERE 
		ha.HelpAgentID = '1124987276'
	GROUP BY DATE_TRUNC('year', o.OrderDate)
	ORDER BY Year;

-- 3. Number of customers along with complaints who have given ratings of 4 and more. 
SELECT 
	ha.HelpAgentID,
	ha.Name,
	COUNT(TicketNo) AS NoComplaints
FROM 
	Complaints c
JOIN
	HelpAgents ha ON ha.HelpAgentID = c.HelpAgentID
WHERE 
	c.Rating >= 4 AND ha.HelpAgentID = '1124987276'
GROUP BY
	ha.HelpAgentID,ha.Name;

-- 4. Total Earnings based on No of Complaints handled. 
SELECT 
	ha.HelpAgentID,
	ha.Name,
	50 * COUNT(TicketNo) AS TotalEarnings
FROM 
	Complaints c
JOIN
	HelpAgents ha ON ha.HelpAgentID = c.HelpAgentID
WHERE 
 	ha.HelpAgentID = '1124987276'
GROUP BY
	ha.HelpAgentID,ha.Name;
	

-- For Delivery Agents
-- 1. Total number of orders delivered in a day/week/month/year.
	-- a) Daily
	SELECT
		da.DelAgentID,
		da.Name AS NAME,
		DATE(o.OrderDate) AS OrderDate,
		COUNT(*) AS TotalOrders
	FROM 
	    Orders o
	JOIN 
	    DeliveryAgents da ON da.DelAgentID = o.AgentID
	WHERE 
		da.DelAgentID = '4916363818'
	GROUP BY DATE(o.OrderDate),da.DelAgentID,da,Name
	ORDER BY OrderDate;

	-- b) Weekly
	SELECT
	    DATE_TRUNC('week', o.OrderDate) AS WeekStartDate,
	    COUNT(*) AS TotalComplaints
	FROM 
	    Orders o
	JOIN 
	    DeliveryAgents da ON da.DelAgentID = o.AgentID
	WHERE 
		da.DelAgentID = '4916363818'
	GROUP BY DATE_TRUNC('week', o.OrderDate),da.DelAgentID,da.Name
	ORDER BY WeekStartDate;
	
	-- c) Monthly
	SELECT
	    DATE_TRUNC('month', o.OrderDate) AS Month,
	    COUNT(*) AS TotalComplaints
	FROM 
	    Orders o
	JOIN 
	    DeliveryAgents da ON da.DelAgentID = o.AgentID
	WHERE 
		da.DelAgentID = '4916363818'
	GROUP BY DATE_TRUNC('month', o.OrderDate),da.DelAgentID,da.Name
	ORDER BY Month;
	
	-- d) Yearly
	SELECT
	    DATE_TRUNC('year', o.OrderDate) AS Year,
	    COUNT(*) AS TotalComplaints
	FROM 
	    Orders o
	JOIN 
	    DeliveryAgents da ON da.DelAgentID = o.AgentID
	WHERE 
		da.DelAgentID = '4916363818'
	GROUP BY DATE_TRUNC('year', o.OrderDate),da.DelAgentID,da.Name
	ORDER BY Year;
	

-- 2. Number of customers along with orders who have given ratings of 4 and more.
SELECT 
	da.DelAgentID,
	da.Name,
	COUNT(OrderID) AS NoOrders
FROM 
	Orders o
JOIN
	DeliveryAgents da ON da.DelAgentID = o.AgentID
WHERE 
	o.Rating >= 4 AND da.DelAgentID = '1155601948'
GROUP BY
	da.DelAgentID,da.Name;

-- 3. Total Earnings based on DeliveryFee.
SELECT 
	da.DelAgentID,
	da.Name,
	SUM(o.DeliveryFee) AS TotalEarnings
FROM 
	Orders o
JOIN
	DeliveryAgents da ON da.DelAgentID = o.AgentID
WHERE 
 	da.DelAgentID = '1155601948'
GROUP BY
	da.DelAgentID,da.Name;


-- For Admin
-- 1. Customers who have bought a gold membership.
	-- a) All customers who have gold membership.
		SELECT 	* FROM Customers WHERE Type = true;
		
	-- b) All customers whose membership is going to expire in a month.
	SELECT 
		CustID,
		CustName,
		Email, 
		ExpiryDate
	FROM 
		Customers
	WHERE 
		ExpiryDate BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '1 month';

-- 2. Average customer ratings for a particular delivery partner.
SELECT 
		d.DelAgentID,
		d.Name,
		COUNT(o.OrderID) AS NoOrders, 
		AVG(o.Rating) AS AvgRating
	FROM 
		DeliveryAgents d 
	JOIN
		Orders o ON d.DelAgentID = o.AgentID
	GROUP BY
		d.DelAgentID,d.Name;

-- 3. Average customer ratings for a particular help agent.
SELECT 
		h.HelpAgentID,
		h.Name,
		COUNT(c.TicketNo) AS NoComplaints, 
		AVG(c.Rating) AS AvgRating
	FROM 
		HelpAgents h 
	JOIN
		Complaints c ON h.HelpAgentID = c.HelpAgentID
	GROUP BY
		h.HelpAgentID,h.Name;

-- 4. List of Refunds.
SELECT 
			r.RefundID,
			r.Amount AS AmtRefunded,
			r.TransactionID,
			c.TicketNo,
			c.Type,
			c.Description,
			c.OrderID,
			cust.CustName
		FROM
			RefundDetails r
		JOIN
			Complaints c ON r.TicketNo = c.TicketNo
		JOIN
			Orders o ON o.OrderID = c.OrderID
		JOIN 
			Customers cust ON cust.CustID = o.CustID;
			
-- 5. Number of orders, deliveries, and total sales on a given day, month or period.
SELECT 
    COUNT(*) AS TotalOrders,
    SUM(CASE WHEN Status = 'Delivered' THEN 1 ELSE 0 END) AS TotalDeliveries,
    SUM(CASE WHEN Status = 'Delivered' THEN Amount ELSE 0 END) AS TotalSales
FROM 
	Orders
WHERE 
	OrderDate BETWEEN '2024-10-01 01:00:00' AND '2024-11-07 00:00:00';

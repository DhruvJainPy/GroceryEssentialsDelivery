-- 1. Customers Table
CREATE TABLE Customers (
    CustID VARCHAR(10) PRIMARY KEY,
    CustName VARCHAR(70) NOT NULL,
    Type BOOL NOT NULL,  -- Assuming Customer Type (Non/Premium) is required.
    ExpiryDate TIMESTAMP,
    Phone_No CHAR(10) NOT NULL UNIQUE,  
    Email VARCHAR(50) NOT NULL UNIQUE 
);

-- 2. Cities Table
CREATE TABLE Cities(
	Pincode VARCHAR(6) PRIMARY KEY,
    State VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL
);

-- 3. CustAddress Table
CREATE TABLE CustAddress (
    CustID VARCHAR(10) NOT NULL,
    AddressId VARCHAR(10) PRIMARY KEY,
    Pincode VARCHAR(6) NOT NULL,
   	FlatNo VARCHAR(50),
    Landmark VARCHAR(100),
    Category VARCHAR(30) NOT NULL,
    FOREIGN KEY (CustID) REFERENCES Customers(CustID),
	FOREIGN KEY(Pincode) REFERENCES Cities(Pincode)
);

-- 4. Categories Table
CREATE TABLE Categories (
    CategoryID VARCHAR(5) PRIMARY KEY,
    CatName VARCHAR(50) NOT NULL UNIQUE 
);

-- 5. SubCategories Table
CREATE TABLE SubCategories (
    SubCategoryID VARCHAR(5) PRIMARY KEY,
    SubName VARCHAR(50) NOT NULL,
    CategoryID VARCHAR(5) NOT NULL,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);


-- 6. Products Table
CREATE TABLE Products (
    ProdID VARCHAR(10) PRIMARY KEY,
    ProdName VARCHAR(100) NOT NULL,
    SubCategoryID VARCHAR(5) NOT NULL,
    Brand VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10, 2) NOT NULL,
    Shelf_life VARCHAR(50),
    Size VARCHAR(20),
    FOREIGN KEY (SubCategoryID) REFERENCES SubCategories(SubCategoryID)
);


-- 7. Suppliers Table
CREATE TABLE Suppliers (
    SupplierID VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Location VARCHAR(255),
    Pincode VARCHAR(6) NOT NULL,
	FOREIGN KEY(Pincode) REFERENCES Cities(Pincode)
);

-- 8. Warehouses Table
CREATE TABLE Warehouses (
    WarehouseID VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Location VARCHAR(255),
    Pincode VARCHAR(6) NOT NULL,
	FOREIGN KEY(Pincode) REFERENCES Cities(Pincode)
);

-- 9. SupplyOrders Table
CREATE TABLE SupplyOrders (
    SupplyOrderID VARCHAR(10) PRIMARY KEY,
    WarehouseID VARCHAR(10) NOT NULL,
    SupplierID VARCHAR(10) NOT NULL,
    SupplyDate TIMESTAMP NOT NULL,
    FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- 10. Inventory Table
CREATE TABLE Inventory (
    InventoryID VARCHAR(10) PRIMARY KEY,
    WarehouseID VARCHAR(10) NOT NULL,
    ProdID VARCHAR(10) NOT NULL,
    Quantity INT,
    Min_Quantity INT CHECK (Min_Quantity >= 0),
    SupplyOrderID VARCHAR(10),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID),
    FOREIGN KEY (ProdID) REFERENCES Products(ProdID),
    FOREIGN KEY (SupplyOrderID) REFERENCES SupplyOrders(SupplyOrderID)
);



-- 11. SupplyOrderDetails Table
CREATE TABLE SupplyOrderDetails (
    SupplyOrderID VARCHAR(10) NOT NULL,
    ProdID VARCHAR(10) NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity >= 0),
    Price DECIMAL(10, 2) NOT NULL CHECK (Price >= 0),
    Total DECIMAL(10, 2),
    PRIMARY KEY (SupplyOrderID, ProdID),
    FOREIGN KEY (SupplyOrderID) REFERENCES SupplyOrders(SupplyOrderID),
    FOREIGN KEY (ProdID) REFERENCES Products(ProdID)
);

-- 12. DeliveryAgents Table
CREATE TABLE DeliveryAgents (
    DelAgentID VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(70) NOT NULL,
    Phone_No CHAR(10) NOT NULL UNIQUE,
    Email VARCHAR(50) NOT NULL UNIQUE,
    Rating DECIMAL(2, 1) CHECK (Rating BETWEEN 0 AND 5),
    No_Deliveries INT DEFAULT 0,
    Earnings DECIMAL(10, 2) DEFAULT 0.0
);

-- 13. Orders Table
CREATE TABLE Orders (
    OrderID VARCHAR(10) PRIMARY KEY,
    AgentID VARCHAR(10),
    CustID VARCHAR(10) NOT NULL,
    Discount DECIMAL(10, 2) DEFAULT 0.0 CHECK (Discount >= 0),
    DeliveryFee DECIMAL(10, 2) NOT NULL CHECK (DeliveryFee >= 0),
    Notes VARCHAR(255),
    Amount DECIMAL(10, 2) NOT NULL CHECK (Amount >= 0),
    Method VARCHAR(20) NOT NULL,
    TransactionID VARCHAR(100) UNIQUE,
    OrderDate TIMESTAMP NOT NULL,
    Timestamp TIMESTAMP,
    Status VARCHAR(40) NOT NULL,
    AddressId VARCHAR(10) NOT NULL,
	Rating INTEGER,
    FOREIGN KEY (AgentID) REFERENCES DeliveryAgents(DelAgentID),
    FOREIGN KEY (CustID) REFERENCES Customers(CustID),
    FOREIGN KEY (AddressID) REFERENCES CustAddress(AddressID) 
);

-- 14. OrderDetails Table
CREATE TABLE OrderDetails (
    OrderID VARCHAR(10) NOT NULL,
    ProdID VARCHAR(10) NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity >= 0),
    Price DECIMAL(10, 2) NOT NULL CHECK (Price >= 0),
    PRIMARY KEY (OrderID, ProdID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProdID) REFERENCES Products(ProdID)
);

-- 15. HelpAgents Table
CREATE TABLE HelpAgents (
    HelpAgentID VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(70) NOT NULL,
    Phone_No CHAR(10) NOT NULL UNIQUE,
    Email VARCHAR(50) NOT NULL UNIQUE,
    Rating DECIMAL(2, 1) CHECK (Rating BETWEEN 0 AND 5),
    Earnings DECIMAL(10, 2) DEFAULT 0.0
);

-- 16. Complaints Table
CREATE TABLE Complaints (
    OrderID VARCHAR(10),
    CustID VARCHAR(10) NOT NULL,
    Type VARCHAR(50) NOT NULL,
    TicketNo VARCHAR(5) PRIMARY KEY,
    HelpAgentID VARCHAR(10),
    Refund BOOL DEFAULT FALSE,
    Description TEXT,
	Rating INTEGER,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (CustID) REFERENCES Customers(CustID),
    FOREIGN KEY (HelpAgentID) REFERENCES HelpAgents(HelpAgentID)
);

-- 17. Cart Table
CREATE TABLE Cart (
    CartID VARCHAR(10) PRIMARY KEY,
    CustID VARCHAR(10) NOT NULL,
    No_Products INT DEFAULT 0,
    Total DECIMAL(10, 2) DEFAULT 0.0,
    FOREIGN KEY (CustID) REFERENCES Customers(CustID)
);

-- 18. CartDetails Table
CREATE TABLE CartDetails (
    CartID VARCHAR(10) NOT NULL,
    ProdID VARCHAR(10) NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity >= 0),
    Sub_Total DECIMAL(10, 2) NOT NULL CHECK (Sub_Total >= 0),
    PRIMARY KEY (CartID, ProdID),
    FOREIGN KEY (CartID) REFERENCES Cart(CartID),
    FOREIGN KEY (ProdID) REFERENCES Products(ProdID)
);

-- 19. RefundDetails Table
CREATE TABLE RefundDetails (
    RefundID VARCHAR(10) PRIMARY KEY,
    Amount DECIMAL(10, 2) NOT NULL CHECK (Amount >= 0),
    TransactionID VARCHAR(100) UNIQUE NOT NULL,
    TicketNo VARCHAR(5) NOT NULL,
    Date TIMESTAMP NOT NULL,
    FOREIGN KEY (TicketNo) REFERENCES Complaints(TicketNo)
);


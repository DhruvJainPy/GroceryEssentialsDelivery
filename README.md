# End-to-End DBMS for Instant Grocery Delivery Platforms

# 🛒 Grocery & Essentials Delivery DBMS

A comprehensive relational database system designed for an online grocery and essentials delivery platform, inspired by real-world models like **Swiggy Instamart**, **Blinkit**, and **Zepto**. This project was built as part of the *DS604: Introduction to Data Management* course.

## 📌 Objective

To design, implement, and normalize a scalable database system to manage:
- Customer details and addresses
- Product catalogs and subcategories
- Warehouses, inventory, and suppliers
- Orders, delivery agents, and payments
- Complaints, refunds, and cart system

---

## 📁 Features

- ✅ **Normalized Schema** (up to BCNF)
- ✅ **18+ Entity-Relationship Tables**
- ✅ **Complex SELECT Queries** for business analytics
- ✅ **Data Ingestion** via realistic `INSERT` scripts
- ✅ **Web Scraper** for simulating product data collection

---

## 🗃️ Database Schema

- **Customers & Addresses**
- **Products, Categories, Subcategories**
- **Orders & Order Details**
- **Warehouses & Inventory**
- **Suppliers & Supply Orders**
- **Delivery Agents & Helpdesk**
- **Carts, Complaints, Refunds**

👉 See the full schema in [`SQL Relational Schema.pdf`](./SQL%20Relational%20Schema.pdf)

---

## 🧠 Normalization

All major relations are normalized to **BCNF**, ensuring:
- No redundancy
- Improved consistency
- Optimized performance

📄 Refer to [`Normalisation Proof.pdf`](./Normalisation%20Proof.pdf) for functional dependencies and decomposition.

---

## 🧪 SQL Queries

Includes a rich set of queries for:

- Product filtering (price, brand, availability)
- Customer order history
- Inventory and reorder tracking
- Supplier performance analysis
- Popular product insights

📂 View in [`SELECT Queries.sql`](./SELECT%20Queries.sql)

---

## 📦 Files Overview

| File | Description |
|------|-------------|
| `DDL.sql` | Table creation scripts |
| `INSERT Queries.sql` | Data population for all entities |
| `SELECT Queries.sql` | SQL queries for real-world use cases |
| `Normalisation Proof.pdf` | BCNF normalization documentation |
| `SQL Relational Schema.pdf` | Complete entity schema |
| `T01_Grocery&EssentialsDelivery.pdf` | Project scope and use case description |

---

## 📚 Technologies Used

- PostgreSQL / MySQL
- SQL (DDL, DML)
- ER Modeling tools (draw.io / dbdiagram.io)
- Jupyter Notebook
  
---

## 🏁 Getting Started

1. Clone the repository  
   ```bash
   git clone https://github.com/your-username/grocery-delivery-dbms.git
   cd grocery-delivery-dbms

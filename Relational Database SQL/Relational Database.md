# 📚 Relational Databases (R-DBMS) & SQL Basics

## 📝 What is an R-DBMS?

A database that stores data in tables (rows & columns) and uses **relationships** (keys) to connect those tables.

* **Why it’s called “Relational”**: Because tables are related to each other using keys:
    * **Primary Key (PK)**: Uniquely identifies a row.
    * **Foreign Key (FK)**: References the Primary Key (PK) of another table.

### Key Characteristics

* Data is stored in **tables**.
* Each table has **rows** (records) and **columns** (fields).
* Uses **SQL** for querying.
* Supports **ACID properties** (safe, consistent operations).
* Prevents data duplication using relationships.

### Example: PK and FK Relationship

| Table | Column | Role |
| :--- | :--- | :--- |
| **Books** | `author_id` | **Foreign Key** (references Authors) |
| **Authors** | `author_id` | **Primary Key** (uniquely identifies author) |

**Data Example:**

| Books (`id`, `title`, `author_id`, `year`) | Authors (`author_id`, `name`) |
| :--- | :--- |
| `1`, `Dune`, `3`, `1965` | `3`, `Frank Herbert` |
| `2`, `Mistborn`, `4`, `2006` | `4`, `Brandon Sanderson` |

---

## ✨ Why R-DBMS is Powerful

* Prevents **duplicate** author names.
* If an author changes name $\rightarrow$ update once.
* You can **join tables** using PK $\rightarrow$ FK.
* Keeps data organized, clean, and efficient.

## 🔗 Basic Relationship Types

| Type | Syntax | Description | Example | Requirement |
| :--- | :--- | :--- | :--- | :--- |
| **One-to-One** | `1:1` | One row relates to exactly one row in another table. | Each book $\leftrightarrow$ One ISBN record. | Direct FK reference. |
| **One-to-Many** | `1:N` | **Most common**. One row relates to many rows in another table. | One author $\rightarrow$ Many Books. | Direct FK reference. |
| **Many-to-Many** | `N:N` | Multiple rows relate to multiple rows in another table. | Books $\leftrightarrow$ Genres. | **Requires a junction table.** |

---

## 🤝 SQL JOINs (Used to combine related tables)

### **✅ A filter that works AFTER GROUP BY!**

The answer is **`HAVING`**.

### ✅ What is a JOIN?

A join is used to **combine rows** from two or more tables based on a related column.

| JOIN Type | Description | Key Idea/Analogy |
| :--- | :--- | :--- |
| **INNER JOIN** | Returns rows where there is a **match in both tables**. If a record doesn’t have a matching key, it is excluded. | Only match the items that are present in both boxes. |
| **LEFT JOIN** | Returns **all rows from the left table** and the matching rows from the right table (or `NULL` if no match). | Give me all the book cards, and if the author exists, attach them. If not, put `NULL`. |
| **RIGHT JOIN** | Returns **all rows from the right table** and the matching rows from the left table (or `NULL` if no match). | Give me all the author cards, and if the book exists, attach it. If not, put `NULL`. |
| **FULL JOIN** | Returns **all rows** when there is a match in one of the tables. Unmatched rows are filled with `NULL`. | Give me all the cards from both boxes, match them if possible. If not, still include them with `NULL` on the missing side. |
| **CROSS JOIN** | Combines every row from the first table with every row from the second table. | Like making all possible pairs. |

### **INNER JOIN Syntax Example**

```sql
SELECT columns
FROM table1
INNER JOIN table2
  ON table1.column = table2.column;
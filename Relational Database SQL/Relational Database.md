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

### 👉 **LEFT JOIN**
Give me **all the book cards**, and **if the author exists**, attach them.
If not, put **NULL**.

```sql
SELECT *
FROM "sea_lions"
LEFT JOIN "migrations"
ON "migrations"."id" = "sea_lions"."id";
```

---

### 👉 **RIGHT JOIN**
Returns **all rows from the RIGHT table** & matches from the LEFT table.

```sql
SELECT *
FROM "sea_lions"
RIGHT JOIN "migrations"
ON "migrations"."id" = "sea_lions"."id";
```

---

### 👉 **FULL JOIN**
Give me **all cards from BOTH tables**,
match them if possible—otherwise **NULL** on missing side.

---

### 👉 **CROSS JOIN**
Combine **every book with every author**.
Like making **all possible pairs**.

---

## 📘 Example Tables

### `books` Table

| id | title      | author_id |
|----|------------|-----------|
| 1  | Dune       | 3         |
| 2  | Mistborn   | 4         |
| 3  | The Hobbit | 5         |

### `authors` Table

| author_id | name              |
|-----------|-------------------|
| 3         | Frank Herbert     |
| 4         | Brandon Sanderson |
| 5         | J.R.R. Tolkien    |

---

## 1️⃣ **INNER JOIN – Most Common**
> Returns rows where **both tables have matching values.**

---

# 🧠 Nested Queries (SUB-QUERIES)

### ❓ **What is a Sub-query?**
A query **inside another query**.

### ❓ **Why use Sub-queries?**
✔ When one result depends on another
✔ When JOINs get messy
✔ For filtering using another query
✔ For using calculations inside a query

### 🔢 **Types of Sub-queries**
1. Sub-query in `WHERE`
2. Sub-query in `SELECT`
3. Sub-query in `FROM`
4. Co-related sub-query

---

## 🔍 1️⃣ **Sub-query in WHERE (Most Important)**

**Goal:** Get books with the **highest rating**

### Step 1 — Find highest rating
```sql
SELECT MAX(rating) FROM library;
```

### Step 2 — Use inside another query
```sql
SELECT title, rating
FROM library
WHERE rating = (SELECT MAX(rating) FROM library);
```

✔ This returns **only top rated books**.

---

## 📊 2️⃣ **Sub-query in SELECT**
Show each book + the **average price** of all books:

```sql
SELECT title, price,
       (SELECT AVG(price) FROM library) AS avg_price_of_library
FROM library;
```

👉 Every row will show **same average value**.

---

## 🔑 IN (Important)
Used to **check if a value exists** in a list/query.

---

### ⚠️ REMEMBER
| Concept | Purpose |
|--------|---------|
| **Foreign Key (FK)** | Connects tables |
| **Joins** | Reads data across tables |
| **PK–FK relationship** | Basis of all JOINs |

---

# 📦 SET Operations (Combining Queries)

### 🔥 1. **UNION** → Removes duplicates
```sql
SELECT "name" FROM "translators"
UNION
SELECT "name" FROM "authors";
```

```sql
SELECT 'author' AS "profession", "name" FROM "authors"
UNION
SELECT 'translator' AS "profession", "name" FROM "translators";
```

---

### 🔥 2. **UNION ALL** → Keeps duplicates
```sql
SELECT 'author' AS "profession", "name" FROM "authors"
UNION ALL
SELECT 'translator' AS "profession", "name" FROM "translators";
```

---

### 🔥 3. **INTERSECT** → Common rows only
```sql
SELECT "book_id" FROM "translated"
WHERE "translator_id" = (
      SELECT "id" FROM "translators" WHERE "name" = 'Sophie Hughes'
)
INTERSECT
SELECT "book_id" FROM "translated"
WHERE "translator_id" = (
      SELECT "id" FROM "translator" WHERE "name" = 'Margaret Jull Costa'
);
```

```sql
SELECT "name" FROM "authors"
INTERSECT
SELECT "name" FROM "translators";
```

---

### 🔥 4. **EXCEPT / MINUS** → Rows from FIRST query **not in second**
```sql
SELECT "name" FROM "authors"
EXCEPT
SELECT "name" FROM "translators";
```
# SQL Notes

## GROUP BY
It groups rows based on one or more columns, and then can perform aggregate functions:

1. COUNT()
2. SUM()
3. AVG()
4. MAX()
5. MIN()

```
SELECT AVG("rating") FROM "ratings";
```
Returns one single value → the average rating of all ratings in the table.

```
SELECT "book_id", AVG("rating") AS "average rating"
FROM "ratings"
GROUP BY "book_id";
```

Example: Find how many ratings each book has:

```
SELECT "book_id", COUNT("rating")
FROM "ratings"
GROUP BY "book_id";
```

---

## HAVING
A filter that works **after** GROUP BY.

Example table: `ratings(book_id, rating)`

❌ Wrong:
```
SELECT book_id, AVG(rating)
FROM ratings
WHERE AVG(rating) > 3;
```

✔ Correct:
```
SELECT book_id, AVG(rating)
FROM ratings
GROUP BY book_id
HAVING AVG(rating) > 3;
```

### Practice Question 1
Show each book_id and total ratings, only books with ≥ 5 ratings.

```
SELECT book_id, COUNT(rating) AS total_rating
FROM ratings
GROUP BY book_id
HAVING total_rating >= 5
ORDER BY total_rating DESC;
```

### Practice Question 2
Average rating rounded to 1 decimal, only books ≥ 4.5 rating.

```
SELECT book_id, ROUND(AVG(rating),1) AS avg_rating
FROM ratings
GROUP BY book_id
HAVING AVG(rating) >= 4.5
ORDER BY avg_rating DESC;
```

### Practice Question 3
Reviews per reviewer, only >10 reviews.

```
SELECT reviewer, COUNT(*) AS total_reviews
FROM reviews
GROUP BY reviewer
HAVING COUNT(*) > 10
ORDER BY total_reviews DESC;
```

---

## Soft Deletion
Soft delete marks a row as deleted instead of removing it.

### Hard Delete
```
DELETE FROM users WHERE id = 10;
```

### Soft Delete
Step 1:
```
ALTER TABLE users ADD is_deleted BOOLEAN DEFAULT FALSE;
```

Step 2:
```
UPDATE users SET is_deleted = TRUE WHERE id = 10;
```

Step 3: Fetch active rows
```
SELECT * FROM users WHERE is_deleted = FALSE;
```

### Soft Delete Trigger
```
CREATE TRIGGER soft_delete_user
BEFORE DELETE ON users
FOR EACH ROW
BEGIN
    UPDATE users
    SET is_deleted = TRUE,
        deleted_at = NOW()
    WHERE id = OLD.id;

    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Soft delete performed. Actual delete blocked.';
END;
```

---

## SQL Views
A VIEW is a virtual table that shows saved query results.

### Create View
```
CREATE VIEW fiction_books AS
SELECT title, author
FROM library
WHERE genre = 'fiction';
```

### Join View
```
CREATE VIEW book_details AS
SELECT library.title, library.author, publisher.name AS publisher_name
FROM library
JOIN publishers ON library.pub_id = publishers.id;
```

### Update View
```
CREATE OR REPLACE VIEW fiction_books AS
SELECT title, author, year
FROM library
WHERE genre = 'fiction';
```

### Delete View
```
DROP VIEW fiction_books;
```

---

## Why Use Views?
- **Simplifying** complex queries
- **Aggregating** data (SUM, COUNT, AVG)
- **Partitioning** filtered data
- **Securing** by hiding sensitive columns

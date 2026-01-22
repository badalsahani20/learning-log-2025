# 🧠 Common Table Expressions (CTE) & SQL Views — Clean Notes

---

## 🧠 What is a CTE?

A **Common Table Expression (CTE)** is like a **temporary result table** that:

- Exists **only for one query**
- Is created using the `WITH` keyword
- Acts as a **named query** you can reuse inside another query

Think of it as a **temporary, readable alias for a subquery**.

---

## 🧾 CTE Syntax

```sql
WITH cte_name AS (
    SELECT ...
)
SELECT * FROM cte_name;
```

✔ Improves readability  
✔ Helps break complex queries into logical steps  
✔ Exists only during query execution  

---

# 🔍 Views in SQL

## 🔍 Do We Have Access to Information Using a VIEW?

✔ **Yes!**

A **VIEW** allows us to **read/access data as if it were a table**.

- We do **not** touch the original table
- We interact with data **through the view**

---

## 🧾 Creating a VIEW

```sql
CREATE VIEW public_books AS
SELECT title, author
FROM library;
```

### Accessing the VIEW

```sql
SELECT * FROM public_books;
```

---

## 🛡 Security Point

A **VIEW can hide sensitive data** while still allowing users to access **only what they need**.

---

## 🔍 Example — Without Security (BAD Practice)

```sql
SELECT * FROM users;
```

This might expose:

| id | name | email | password | salary | phone |
|----|------|-------|----------|--------|-------|

⚠ **BAD PRACTICE!**  
Never allow unrestricted access to sensitive data.

---

## ✔ Secure Way — Using VIEW

```sql
CREATE VIEW public_users AS
SELECT name, email
FROM users;
```

Now users can run:

```sql
SELECT * FROM public_users;
```

They will ONLY see:

| name | email |
|------|-------|

🔒 **Hidden:** password, salary, phone

---

## 🔍 Real-World Use Cases for VIEWs

| Situation | Solution using VIEW |
|--------|------------------|
| Interns shouldn’t see salaries | View without salary column |
| Admin panel needs summary data | View with aggregation |
| Clients should see only active data | View with `WHERE is_active = TRUE` |
| Prevent exposing passwords | Never include passwords in views |

---

## 👮 Extra Security — GRANT Permissions

```sql
GRANT SELECT ON public_users TO normal_users;
```

✔ User can access **view only**  
❌ Cannot access `users` table directly

---

## 🚫 Block Access to Original Table

```sql
REVOKE SELECT ON users FROM normal_users;
```

Now:
- ❌ No access to base table
- ✔ Access allowed only through the view

---

## 🧠 Database Security Layer

You’re telling SQL:

> “Show this data — **BUT ONLY through this view**.  
> Keep the original table safe.”

---

## 🧠 In a Nutshell — Why Views Matter

- Data abstraction
- Restricted data access
- Hide sensitive columns
- Grant access to views, **not tables**
- Prevent accidental data leaks
- Ideal for:
  - Admin panels
  - APIs
  - Backend services

---

## 🗂 SQL Databases & VIEW Permissions

| Database | Supports GRANT? | Controls VIEW Access? |
|--------|---------------|----------------------|
| MySQL | ✔ Yes | ✔ Yes |
| PostgreSQL | ✔ Yes | ✔ Yes |
| SQL Server | ✔ Yes | ✔ Yes |
| Oracle | ✔ Yes | ✔ Yes |
| SQLite | ❌ No | ❌ No |

---

## 🔒 SQLite Limitation

SQLite is:
- Lightweight
- File-based
- No users, roles, or permissions

⚠ **Result:**
- Cannot `GRANT` or `REVOKE`
- Cannot restrict access to views

---

# 🧹 Soft Deletion + VIEW (Clean & Secure Pattern)

## ⚠ Problem

We soft delete records:

```text
is_deleted = TRUE
```

But:
- Normal queries still show deleted data 😵

---

## ✅ Solution — Use VIEW

Expose **only active data** via a view.

---

## ⚙ Step 1: Add Soft Delete Columns

```sql
ALTER TABLE library
ADD is_deleted BOOLEAN DEFAULT FALSE,
ADD deleted_at DATETIME NULL;
```

---

## 🧹 Step 2: Perform Soft Delete

```sql
UPDATE library
SET is_deleted = TRUE,
    deleted_at = NOW()
WHERE id = 10;
```

---

## 👓 Step 3: Create VIEW for Active Data

```sql
CREATE VIEW active_books AS
SELECT *
FROM library
WHERE is_deleted = FALSE;
```

---

## 🧠 Bonus — Prevent Real DELETE Using Trigger

```sql
CREATE TRIGGER prevent_hard_delete
BEFORE DELETE ON library
FOR EACH ROW
BEGIN
    UPDATE library
    SET is_deleted = TRUE,
        deleted_at = NOW()
    WHERE id = OLD.id;

    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Hard delete blocked. Soft delete applied.';
END;
```

---

## ✅ Final Takeaway

- **CTEs** → Temporary, readable query helpers  
- **Views** → Security + abstraction layer  
- **Soft deletes + views** → Clean, safe, production-ready pattern  
- **Triggers** → Enforce rules at database level  

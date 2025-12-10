

## 🧠 What is Normalization?
Normalization organizes data to:
1. Reduce redundancy
2. Improve data integrity
3. Make maintenance easier

**In simple words:** break a large messy table into smaller related tables so every piece of information is stored only once.

---

## 📚 Example (Unnormalized Table)

| student_id | student_name | course1 | course2 | instructor |
|------------|--------------|---------|---------|------------|
| 1 | Badal | DBMS | Java | Lovepreet |
| 2 | Ruchi | Java | DSA | Lovepreet |

### ❌ Problems
- Instructor name repeats
- Hard-coded course columns
- Difficult to add new courses
- Redundant data

---

## 🧩 After Normalization (3NF)

### 🧱 Table 1: Students
| student_id | student_name |
|------------|--------------|
| 1 | Badal |
| 2 | Ruchi |

### 🧱 Table 2: Courses
| course_id | course_name | instructor |
|-----------|-------------|------------|
| 101 | DBMS | Lovepreet |
| 102 | Java | Lovepreet |
| 103 | DSA | Lovepreet |

### 🧱 Table 3: StudentCourses
| student_id | course_id |
|------------|------------|
| 1 | 101 |
| 1 | 102 |
| 2 | 102 |
| 2 | 103 |

### ✅ Benefits
- No duplicate instructor names
- Easy to add/remove courses
- Clean relationships through foreign keys

---

## 🧩 Forms of Normalization (Interview Friendly)

| Normal Form | Purpose | Example Fix |
|-------------|---------|--------------|
| **1NF** | No repeating columns, atomic values | course1, course2 → move to rows |
| **2NF** | Every non-key must depend on whole key | Split student-course table |
| **3NF** | No transitive dependencies | Move instructor to separate table |

> After 3NF, 90% of real databases are clean enough.

---

## 🧵 What Are Data Types in SQL?
A data type defines what a column can store (numbers, text, dates, etc.).
They ensure **validity, safety, and consistency**.

---

## 🧱 Categories of SQL Data Types

### 1️⃣ Numeric Types

#### **INT / INTEGER**
- Whole numbers (no decimals)
- Examples: `10`, `999`, `-50`
- Used for: IDs, counts, years

#### **REAL / FLOAT / DOUBLE**
- Decimal numbers
- Not accurate → bad for money

#### **DECIMAL(p, q) / NUMERIC(p, q)**
- Exact decimal values
- Example: `DECIMAL(10,2)` → `99999999.99`
- Used for: money, accurate scientific values

---

### 2️⃣ Text Types

#### **VARCHAR(n) / TEXT**
- `VARCHAR(n)` → fixed max length
- `TEXT` → long text
- Used for: names, emails, descriptions

---

### 3️⃣ Date & Time Types

- **DATE** → `2025-01-12`
- **TIME** → `15:45:00`
- **DATETIME / TIMESTAMP** → `2025-01-12 15:45:00`

Used for: createdAt, updatedAt, logs, orders

---

### 4️⃣ Boolean
- **BOOLEAN / BOOL**
- TRUE/FALSE or 1/0

---

### 5️⃣ Special Types
- **BLOB** → images, files, binary data

---

## 💰 Best Data Type for Money?
### ✅ Always Use `DECIMAL`
Floating types cause rounding errors:

`0.1 + 0.2 = 0.30000000000004`

Money must be exact → use `DECIMAL(10,2)`.

---

## 🧱 SQL Table Creation Examples

```sql
CREATE TABLE riders (
 id INTEGER PRIMARY KEY AUTO_INCREMENT,
 name VARCHAR(50) NOT NULL
);

CREATE TABLE stations(
 id INTEGER PRIMARY KEY AUTO_INCREMENT,
 name VARCHAR(50) NOT NULL,
 line VARCHAR(100)
);

CREATE TABLE visits (
 rider_id INT NOT NULL,
 station_id INT NOT NULL,
 FOREIGN KEY (rider_id) REFERENCES riders(id),
 FOREIGN KEY (station_id) REFERENCES stations(id)
);
```

---

## 🚀 ALTER TABLE (SQL)

### 1. Add column
```sql
ALTER TABLE riders ADD email VARCHAR(50);
```

### 2. Drop column
```sql
ALTER TABLE riders DROP COLUMN email;
```

### 3. Rename column
```sql
ALTER TABLE riders RENAME COLUMN name TO full_name;
```

### 4. Modify datatype
```sql
ALTER TABLE riders MODIFY email VARCHAR(200);
```

### 5. Add foreign key
```sql
ALTER TABLE visits
ADD CONSTRAINT fk_rider
FOREIGN KEY (rider_id) REFERENCES riders(id);
```

---

## ✅ INSERT (Add Data)

### Insert one row
```sql
INSERT INTO riders (name) VALUES ('Badal');
```

### Insert multiple rows
```sql
INSERT INTO riders(name)
VALUES ('Ruchi'), ('Ayan'), ('Meera');
```

### Insert into table with foreign keys
```sql
INSERT INTO visits (rider_id, station_id)
VALUES (1, 1), (1, 2), (2, 4), (3, 1);
```

---

## 📥 Import CSV into SQL

```sql
LOAD DATA INFILE 'riders.csv'
INTO TABLE riders
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

---

## 🗑️ DELETE (Remove Data)

### Delete with where clause
```sql
DELETE FROM riders WHERE id = 2;
```

### Important: Primary key does NOT reorder
If you delete ID = 2, next auto-increment will be 4, not 2.

---

## 🔗 Deleting with Foreign Keys

To automatically delete child rows:

```sql
FOREIGN KEY (rider_id) REFERENCES riders(id) ON DELETE CASCADE
```

---

## 🔠 SQL STRING FUNCTIONS

| Function | Purpose | Example |
|----------|----------|----------|
| `UPPER()` | Uppercase | `UPPER('badal') → BADAL` |
| `LOWER()` | Lowercase | `LOWER('BADAL') → badal` |
| `TRIM()` | Remove spaces | `TRIM(' badal ') → badal` |

---

## 🚀 SQL TRIGGERS

### Definition
A trigger automatically runs when INSERT/UPDATE/DELETE happens.

### Use cases
- Loggi
- Auto-updates
- Validation
- Notifications

---

## 🛒 Example: Reducing Stock After Sale

### Trigger
```sql
CREATE TRIGGER reduce_stock_after_sale
AFTER INSERT ON sales 
FOR EACH ROW
BEGIN 
 UPDATE products
 SET stock = stock - NEW.quantity
 WHERE id = NEW.product_id;
END;
```

### Underflow protection
```sql
CREATE TRIGGER prevent_stock_underflow
BEFORE INSERT ON sales
FOR EACH ROW
BEGIN
 DECLARE current_stock INT;
 SELECT stock INTO current_stock
 FROM products
 WHERE id = NEW.product_id;

 IF current_stock < NEW.quantity THEN
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'Not enough stock!';
 END IF;
END;
```


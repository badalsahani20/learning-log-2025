                    DataBase Introduction 
✅Database
->
A structured collection of data stored so it can be efficiently created, read, updated, and deleted (CRUD).
 
Database Management System:
Software that helps manage & interact with databases.
Examples: MySQL, PostgreSQL, Oracle, SQLite.

✅SQL
Language used to define, manipulate, and query data in relational databases. 
! -> SQL is not a DB, it is the language.

Querying: (Which songs are most like the song a user just played?)

What data do we have in our database?
it could be anything(Book details, Car Details, any entity).
query:
SELECT (upperCase to identify which word is sql keyword) *(all) FROM "library";
-> It will give you all the details about the books like title, author(depends how the data has been stored).

query:
SELECT "title" from "library";
-> will return only the name of the Books stored in the database.

query:
SELECT "title", "author" from "library";
-> we can have multiple columns -> it will return Game of thrones -> George R.R and tons of them.
Important: These queries will return all the list of books and authors but the data could be of thousands of books. If we want few data or for instance we want all the books within 100 Books. For that to achieve we use LIMIT keyword.
Eg:
SELECT "title", "author" FROM "library" LIMIT 100;
The Query will only return the details of 100 Books from the library. 

### Query:
SELECT "title", "author" from "library";
-> we can have multiple columns -> it will return Game of thrones -> George R.R and tons of them.

Important: These queries will return all the list of books and authors but the data could be of thousands of books. If we want few data or for instance we want all the books within 100 Books. For that to achieve we use LIMIT keyword.

Eg:
SELECT "title", "author" FROM "library" LIMIT 100;
The Query will only return the details of 100 Books from the library.

---

### ✅ WHERE:
The where clause allows us to retrieve only those rows from a table that meets a specified condition. It is used to filter data before it is returned or processed.

Eg: Let us say we want all the books nominated in 2022.
SELECT name, author from library where year = 2021; -> That is it. We will get all the books nominated in 2021.

---

### != (Not Equals) or <> (also Not Equals and works the same):
Filters rows where the column value does not match the given value.

**Query:**
SELECT title, format FROM library WHERE format != 'hardcover';
(Format could be types like hardcover, paperback, leather cover, etc.)

**Query:**
SELECT title, format FROM library WHERE format <> 'hardcover';
This query returns all books where the format is not hardcover.

---

### NOT (NOT returns rows where the condition is false.):
**Query:**
SELECT title, format FROM library WHERE NOT format = 'hardcover';
Works the same as != or <> just different style.

---

### ✅ AND:
Used when all conditions must be true. Filters records only if every condition matches.

**Eg:**
Q: Find Books that are fiction And hardcover?
**Query:**
SELECT title, genre, format FROM library WHERE genre = 'fiction' AND format = 'hardcover';
As a result, we will get the books from genre fiction and the format is hardcover.

---

### OR:
Used when any one condition is true. Returns rows if at least one condition matches.

**Example:**
Q: Find books that are either fiction OR hardcover:
**Query:**
SELECT title, genre, format FROM library WHERE genre = 'dark romance' OR format = 'hardcover';

---

### ✅ () Parentheses:
Used to group conditions.
Controls precedence (order of evaluation).
Works like in math: expression inside () runs first.

**Example:**
Q: Find books that are fiction AND (hardcover OR leather)?
**Query:**
SELECT title, genre, format FROM library WHERE genre = 'fiction' AND (format = 'hardcover' OR format = 'leather');

Note: Without parentheses, SQL processes AND before OR, so the result changes.

---

### ✅ NULL:
In SQL, NULL is a special value that means unknown / no value / empty — it's not the same as 0, "" (empty string) or false.

**Example:**
Q: Check the list of books that do not have a translation?
**Query:**
SELECT title, translator FROM library WHERE translator IS NULL;

**Q:** Check the list of books that do have a translation.
**Query:**
SELECT title, translator FROM library WHERE translator IS NOT NULL;

# 🔍 LIKE:
Used to search for patterns in text columns.  
It helps when you do not know the full value — just part of it.

**Pattern Symbols:**  
% -> matches any number of characters (0 or more).  
_ -> matches exactly one character.

Q: Books whose title starts with "Harry".  
Query:
SELECT title FROM library WHERE title LIKE 'Harry%';

Q: Books whose title ends with "King".  
Query:
SELECT title FROM library WHERE title LIKE '%King';

Q: Books where a four letter word starting with "K".  
Query:
SELECT title FROM library WHERE title LIKE 'K____';

---

### _ (Underscore) — SQL Wildcard:
The `_` wildcard matches **exactly ONE** character.

Query:
SELECT title FROM library WHERE title LIKE '____';

Query:
SELECT title FROM library WHERE title LIKE 'K___';

Query:
SELECT title FROM library WHERE title LIKE '__a%';

---

# ⚖ Comparison Operators:

| Operator | Meaning |
|----------|-----------------------------|
| =        | Equal to (case sensitive)   |
| != or <> | Not equal to                |
| >        | Greater than                |
| <        | Less than                   |
| >=       | Greater than or equal to    |
| <=       | Less than or equal to       |

Too Long:
SELECT title, year FROM library WHERE year = 2019 OR year = 2020 OR year = 2021 OR year = 2022;

Better:
SELECT title, year FROM library WHERE year >= 2019 AND year <= 2022;

BETWEEN:
SELECT title, year FROM library WHERE year BETWEEN 2019 AND 2022;

---

# 📌 ORDER BY:
Ascending:
SELECT title, rating FROM library ORDER BY rating LIMIT 10;

Descending:
SELECT title, rating FROM library ORDER BY rating DESC LIMIT 10;

# 📚 SQL Notes – Aggregate Functions

---

## ✅ What Are Aggregate Functions?

An **aggregate operation** takes **multiple rows** and produces **a single summarized value**.
**Aggregate = collect many → return one**

Examples:
- Many book prices → one average price
- Many book pages → one total page count
- Many publication years → one earliest year

---

## 📌 Common Aggregate Functions (Library Example)

| Function  | Meaning                 | Example (Library)                          | What It Returns             |
|-----------|-------------------------|--------------------------------------------|-----------------------------|
| COUNT()   | Counts number of rows   | `SELECT COUNT(*) FROM library;`            | Total number of books       |
| AVG()     | Average value           | `SELECT AVG(price) FROM library;`          | Average price               |
| MIN()     | Smallest value          | `SELECT MIN(year) FROM library;`           | Earliest published year     |
| MAX()     | Largest value           | `SELECT MAX(pages) FROM library;`          | Book with the most pages    |
| SUM()     | Adds values in column   | `SELECT SUM(pages) FROM library;`          | Total pages in library      |

✔ These functions **return a single value**
✔ They are used inside **SELECT queries**
✔ Often used with **GROUP BY**

---

## ⚙ AVG + ROUND + ALIAS (Full Flow)

### ❌ 1. Raw AVG gives long decimal values:
```sql
SELECT AVG(price) FROM library;
```
⚠ Might return: `3.234254234242`

---

### ✔ 2. Use ROUND() to limit decimal places:
```sql
SELECT ROUND(AVG(price), 2) FROM library;
```
Returns: `3.23`

---

### ❌ 3. Problem: The column name becomes ugly:
Example output column name:
```
ROUND(AVG(price),2)
```
Not good for reports or frontend.

---

### ✔ 4. Solution: Use AS (alias) to rename column:
```sql
SELECT ROUND(AVG(price), 2) AS average_price FROM library;
```

**Result:**
| average_price |
|----------------|
| 3.23 |

---

## 🧠 Analogy (Easy to Remember)

Imagine you are looking at 100 books and want **ONE answer**:

| Question | Aggregate Function |
|----------|--------------------|
| “How many books?” | COUNT |
| “What is the average price?” | AVG |
| “What is the earliest book?” | MIN |
| “What has the most pages?” | MAX |
| “What is the total pages if stacked?” | SUM |

All these are **aggregate operations**.

---

## 🔢 COUNT():

```sql
SELECT COUNT(*) FROM library;
```
Returns total items, e.g., `78`

⚠ Interesting Fact:
```sql
SELECT COUNT(translator) FROM library;
```
Returns `76` instead of `78`

**Why?**  
- `COUNT(*)` counts **all rows** (even NULL)
- `COUNT(column)` ignores **NULL values**

---

## 🔽 MIN() & MAX()

```sql
SELECT MIN(rating) FROM library;  -- 3.05
SELECT MAX(rating) FROM library;  -- 4.60
```

### ❓ How does it work with **strings**?

```sql
SELECT MAX(title), MIN(title) FROM library;
```

Result:
- MAX → `Wretchedness`
- MIN → `A New Name: Septology VI-VII`

**How?**
SQL compares strings in **alphabetical order**:
```
A < B < C < ... < Z
```

| Function | Meaning |
|----------|------------------------------|
| MIN(string) | Returns alphabetically first |
| MAX(string) | Returns alphabetically last  |

---

## ➕ SUM()

```sql
SELECT SUM(votes) FROM library;  -- 60412
```
Returns total value of the column.

---

## 🧹 DISTINCT – Remove Duplicates

Returns only **unique values** from a column.

### Example 1: Unique Authors
```sql
SELECT DISTINCT author FROM library;
```

### Example 2: Unique Genres
```sql
SELECT DISTINCT genre FROM library;
```

Example output:
```
Fiction
Fantasy
Mystery
Romance
Philosophy
```
No duplicates — just unique categories.

---

## ✔ In Summary (For Revision)

```markdown
Aggregate Functions:
- COUNT() → Total number of rows
- AVG() → Average of column values
- MIN() → Smallest value
- MAX() → Largest value
- SUM() → Total sum of column values

Use ROUND() to format AVG
Use AS to rename column
DISTINCT removes duplicate values
COUNT(*) counts NULL rows, COUNT(col) does NOT
```

---




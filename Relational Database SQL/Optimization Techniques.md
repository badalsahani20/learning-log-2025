# 🎬 Designing an IMDB‑Style Database & SQL Optimization — Complete Notes

---

## 🧠 Design Philosophy

👉 First design a **clean database**  
👉 Then **create the schema**  
👉 Then **optimize queries on top of it**

This is how **real backend systems** are built.

---

# 🎬 Step 1 — Requirements

Our IMDB‑style learning database must support:

- ✅ Movies  
- ✅ Actors  
- ✅ Genres  
- ✅ Users (who rate movies)  
- ✅ Ratings (user → movie → rating)

---

# 🧠 Step 2 — Identify Entities (Tables)

From the requirements:

1. `movies`
2. `actors`
3. `movie_cast` (many‑to‑many)
4. `genres`
5. `users`
6. `ratings`

---

# 🧱 Step 3 — Table Design (With Reasoning)

---

## 🎬 1️⃣ movies

Stores basic movie info.

```sql
CREATE TABLE movies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    year INT,
    genre_id INT,
    FOREIGN KEY (genre_id) REFERENCES genres(id)
);
```

**Why not store rating here?**  
Ratings come from **multiple users**, so they belong in a separate table.  
This allows aggregation and indexing.

---

## 🎭 2️⃣ actors

```sql
CREATE TABLE actors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);
```

---

## 🎥 3️⃣ movie_cast (Many‑to‑Many)

```sql
CREATE TABLE movie_cast (
    movie_id INT,
    actor_id INT,
    PRIMARY KEY (movie_id, actor_id),
    FOREIGN KEY (movie_id) REFERENCES movies(id),
    FOREIGN KEY (actor_id) REFERENCES actors(id)
);
```

**Optimization**
- Composite primary key
- Automatic indexing
- Fast JOINs

---

## 📚 4️⃣ genres

```sql
CREATE TABLE genres (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);
```

---

## 👤 5️⃣ users

```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE
);
```

---

## ⭐ 6️⃣ ratings (Core Optimization Table)

```sql
CREATE TABLE ratings (
    user_id INT,
    movie_id INT,
    rating DECIMAL(3,1) NOT NULL,
    rated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, movie_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);
```

**Why composite primary key?**
- A user rates a movie only once
- Automatic optimal indexing
- Fast:
  - “Movies rated by user X”
  - “Average rating of movie Y”

---

# 🎯 Step 4 — ER Relationships

```
genres   1 ───── ★ movies

movies   ★ ───── ★ movie_cast ───── ★ actors

movies   ★ ───── ★ ratings ───── ★ users
```

---

# ⭐ Step 5 — Insert Sample Data

(Genres, Movies, Actors, Cast, Users, Ratings)

*(Included exactly as in your notes — ready for practice & EXPLAIN analysis)*

---

# 🚀 SQL OPTIMIZATION ROADMAP

1. Understand what makes queries slow  
2. Write intentionally slow queries  
3. Use `EXPLAIN` & Visual Explain  
4. Add indexes and compare  
5. Optimize JOINs  
6. Optimize ORDER BY + LIMIT  
7. Optimize GROUP BY + aggregation  
8. Design composite indexes  

---

# 🟦 INDEXING — Core Knowledge

## ⭐ What is an Index?
A sorted **B+Tree** structure:
```
index_key → pointer_to_row
```

Speeds up:
- WHERE
- JOIN
- ORDER BY
- GROUP BY

---

## ⭐ Composite Index & Left‑Most Prefix Rule

```sql
CREATE INDEX idx_city_age ON users(city, age);
```

Works for:
- `WHERE city = ?`
- `WHERE city = ? AND age = ?`

❌ Does NOT work for:
- `WHERE age = ?`

---

## ⭐ Covering Index (Critical Optimization)

```sql
CREATE INDEX idx_user_rating
ON ratings(user_id, rating);
```

✔ Query uses **index only**  
✔ No table access  
✔ Extremely fast

---

# 🧠 QUERY EXECUTION ORDER (FOUNDATION)

Actual execution order:

1. FROM  
2. JOIN  
3. WHERE  
4. GROUP BY  
5. HAVING  
6. SELECT  
7. DISTINCT  
8. ORDER BY  
9. LIMIT  

**Why this matters**
- WHERE filters early
- HAVING is expensive
- ORDER BY without index is deadly

---

# 🧪 EXPLAIN — HOW TO READ PERFORMANCE

## ⭐ type (MOST IMPORTANT)

Worst → Best:
- ALL ❌
- index
- range
- ref
- eq_ref
- const/system ⭐

---

## ⭐ key, rows, Extra

- `key = NULL` → no index used ❌
- `rows` → how many rows touched
- `Using filesort` → slow ORDER BY
- `Using temporary` → slow GROUP BY
- `Using index` → covering index (FAST)

---

# 🔥 ORDER BY OPTIMIZATION (MOST APPS FAIL HERE)

## RULES
- ORDER BY uses index **only if order matches**
- Expressions break indexes
- DESC needs correct index direction
- LIMIT + ORDER BY = massive speedup
- Covering indexes = fastest reads

---

## ⭐ ORDER BY + JOIN (Production Pattern)

```sql
SELECT u.username, r.rating
FROM (
    SELECT user_id, rating
    FROM ratings
    ORDER BY rating DESC
    LIMIT 10
) r
JOIN users u ON u.id = r.user_id;
```

✔ Sort small dataset first  
✔ Then JOIN  
✔ Used in real systems

---

# ✅ Final Takeaways

- Schema design decides performance
- Indexing is a strategy, not guesswork
- EXPLAIN is your debugger
- ORDER BY is the silent killer
- Covering indexes are elite‑level optimization


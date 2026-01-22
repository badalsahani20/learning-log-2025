# 🟦 SQL Transactions — Complete & Practical Notes

---

## ⭐ What is a Transaction?

A **transaction** is a group of SQL operations that must:

- ✔ Either **all succeed** → `COMMIT`
- ❌ Or **all fail** → `ROLLBACK`
- 🚫 No in-between state

This guarantees **data correctness**, especially when **multiple users** access the database simultaneously.

---

## ⭐ 1. Starting a Transaction

```sql
START TRANSACTION;
-- or
BEGIN;
```

This tells the database:

> “I’m about to perform multiple critical operations.  
> Don’t save anything until I explicitly say so.”

---

## ⭐ 2. COMMIT — Save Everything Permanently

```sql
COMMIT;
```

Meaning:

- ✔ All queries succeeded
- ✔ Changes become permanent
- ✔ Locks are released
- ✔ Other users can see the updated data

---

## ⭐ 3. ROLLBACK — Undo Everything

```sql
ROLLBACK;
```

Meaning:

- ❌ Undo ALL operations since transaction start
- 🔄 Restore database to previous state
- 🛡 Very important for error handling
- ✔ Guarantees safety

---

## ⭐ Example — Money Transfer Scenario

**Initial balances**

- User A → `1000 INR`
- User B → `500 INR`

User A sends **300 INR** to User B.

This requires **two operations**:

1. Debit A
2. Credit B

Both must succeed **together**.

---

## ⭐ Without Transaction (DANGEROUS)

```sql
UPDATE accounts SET balance = balance - 300 WHERE id = 1; -- A
UPDATE accounts SET balance = balance + 300 WHERE id = 2; -- B
```

If the first query succeeds but the second fails:

- ❌ A loses 300
- ❌ B gains nothing
- ❌ Money disappears

⚠ **This is why transactions exist.**

---

## ⭐ With Transaction (SAFE)

```sql
START TRANSACTION;

UPDATE accounts SET balance = balance - 300 WHERE id = 1;
UPDATE accounts SET balance = balance + 300 WHERE id = 2;

COMMIT;
```

- ✔ Both succeed → `COMMIT`
- ❌ Any failure → `ROLLBACK`

---

## ⭐ Example with ROLLBACK

```sql
START TRANSACTION;

UPDATE accounts SET balance = balance - 300 WHERE id = 1;
-- error occurs here
UPDATE accounts SET balance = balance + 300 WHERE id = 2;

ROLLBACK;
```

### Result

- ✔ A still has `1000`
- ✔ No money lost
- ✔ Database remains consistent

---

## ⭐ 4. SAVEPOINT — Partial Rollback

```sql
START TRANSACTION;

UPDATE accounts SET balance = balance - 300 WHERE id = 1;
SAVEPOINT after_debit;

-- something goes wrong
ROLLBACK TO after_debit;

COMMIT;
```

✔ Allows rollback to a **specific point**  
✔ Very useful in long transactions  

---

# 🧪 Phase 2 — Deep Concepts

---

## ⭐ 1. ACID Properties (Transaction Foundation)

Every transaction must follow **ACID**:

### 🔹 A — Atomicity (All or Nothing)
- Transaction must fully succeed or fully fail  
- Example: Debit + Credit must both happen

### 🔹 C — Consistency (Valid → Valid State)
- Database rules must never break
- Example: Balance cannot go negative (unless allowed)

### 🔹 I — Isolation (No Interference)
- Concurrent transactions must not corrupt each other
- Controlled using isolation levels

### 🔹 D — Durability (Permanent Data)
Once committed:
- Power failure?
- Server crash?
- OS crash?

✔ Data must remain saved  
✔ Achieved using logs and journals

---

## ⭐ 2. Concurrency Problems (WHY Isolation Matters)

### 1️⃣ Dirty Read
- Transaction A reads uncommitted data from B
- If B rolls back → A read garbage

### 2️⃣ Non-Repeatable Read
- A reads data
- B updates it
- A reads again → different result

### 3️⃣ Phantom Read
```sql
SELECT * FROM users WHERE age > 18;
```
- B inserts a new row (`age = 20`)
- A re-runs query → extra rows appear

### 4️⃣ Lost Update
- Two transactions update same data
- One update overwrites the other

---

## ⭐ 3. Isolation Levels (Visibility Control)

| Level | Description |
|-----|-------------|
| **READ UNCOMMITTED** | Dirty reads allowed (fast but unsafe) |
| **READ COMMITTED** | Only committed data visible (Postgres, Oracle) |
| **REPEATABLE READ** | Same data throughout transaction (MySQL default) |
| **SERIALIZABLE** | Strict sequence, safest, slowest |

---

## ⭐ 4. Locks — How Isolation Is Enforced

### ✔ Shared Lock (Read)
- Many can read
- No writes allowed

### ✔ Exclusive Lock (Write)
- Only one transaction
- Blocks all others

### ✔ Row-Level Lock
- Locks only affected rows
- Used by InnoDB (very fast)

### ✔ Table Lock
- Locks entire table
- Mostly MyISAM

---

## ⭐ 5. MVCC (Multi-Version Concurrency Control)

MySQL’s secret weapon.

✔ Readers don’t block writers  
✔ Writers don’t block readers  

How it works:
- SELECT sees old snapshot
- UPDATE creates new version
- COMMIT makes it visible

Result:
🚀 High performance + safety

---

## ⭐ 6. Deadlocks (Inevitable Reality)

### What is a Deadlock?

- A waits for B
- B waits for A
- No progress possible

MySQL detects this and **rolls back one transaction**.

### Reduce Deadlocks
- Update rows in same order
- Keep transactions short
- Add proper indexes
- Avoid unnecessary `SELECT ... FOR UPDATE`

---

## ⭐ 7. SELECT ... FOR UPDATE (Critical for Safety)

```sql
START TRANSACTION;

SELECT balance FROM accounts WHERE id = 1 FOR UPDATE;
SELECT balance FROM accounts WHERE id = 2 FOR UPDATE;

UPDATE accounts SET balance = balance - 300 WHERE id = 1;
UPDATE accounts SET balance = balance + 300 WHERE id = 2;

COMMIT;
```

✔ Prevents lost updates  
✔ Prevents double spending  
✔ Essential for:
- Banking
- Seat booking
- Stock trading systems

---

## ✅ Final Takeaway

- Transactions protect data integrity
- ACID guarantees correctness
- Isolation levels control concurrency
- MVCC boosts performance
- Proper locking prevents disasters

📌 **This is core backend & database engineering knowledge.**

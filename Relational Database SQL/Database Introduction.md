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
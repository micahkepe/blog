+++
title = "A Deep Dive into SQLite's Query Optimizer"
date = 2024-08-27
draft = false

[taxonomies]
categories = ["databases"]
tags = ["databases", "sqlite", "query-optimizer"]

[extra]
toc = true
+++

I **love** databases, but they are still largely a magical black box to me, so
in this post, I'm going to explore how SQLite's query optimizer works. We'll
delve together into the process of how SQL queries are parsed, optimized, and
executed, with a particular focus on the optimization phase. By the end of this
post, you'll have a better understanding of how SQLite's query optimizer works
and how it can help you write more efficient queries.

<!-- more -->

This past summer, I got a lot of practice learning the ins and outs of SQLite as
part of a project that I have been contributing to, which we originally set up
with a SQLite database. I've been working with SQLite for a while now, and I've
come to appreciate its simplicity and ease of use.

## What Actually Happens When You Run a Query?

Regardless of the database engine you're using, when you run a query, the
database engine goes through a series of steps to execute the query. These steps
include:

1. **Writing**: The query is written and sent to the database engine.
2. **Parsing**: The query is parsed to ensure it is syntactically correct.
3. **Planning**: The query planner generates an execution plan for the query.
4. **Execution**: The query is actually executed and the results are returned.

Of course, while these steps are common to all database engines, the way they
are implemented can vary significantly from one engine to another.

{{ responsive(
    src="overview.png",
    alt="Overview of the query execution process",
    caption="Overview of the query execution process",
    width=60)
}}

## SQLite's Approach to Query Optimization

Because SQLite is open source and has a small codebase, it’s relatively easy to
understand how it works. The query optimizer in SQLite might seem like a modest
engine at first glance, but under the hood, it's a sophisticated piece of
software that makes smart decisions to ensure your queries run efficiently.

SQLite's query optimizer uses several different strategies to optimize query
performance:

1. **Index Selection**: SQLite intelligently selects the best indexes to speed up
   data retrieval. It considers various factors, such as the columns in the `WHERE`
   clause and the order in which they appear.

2. **Join Ordering**: For queries that involve joins, SQLite tries to figure out
   the most efficient order to join the tables. It uses heuristics and statistics
   to make an educated guess that minimizes the computational cost.

3. **Subquery Flattening**: SQLite tries to flatten subqueries, meaning it
   attempts to merge subqueries into the main query whenever possible. This
   reduces the overhead of executing multiple queries separately.

4. **Covering Indexes**: If an index contains all the columns needed by the
   query, SQLite can retrieve the results directly from the index without
   accessing the actual table, significantly speeding up the query.

5. **Cost Estimation**: SQLite uses a cost-based query planner, which estimates
   the cost of different execution plans and chooses the one with the lowest
   estimated cost. The cost is generally a measure of how much disk I/O and CPU
   time will be consumed.

These strategies help SQLite balance efficiency and performance, making it an
excellent choice for applications where lightweight and quick database
operations are essential.

## Simple Example Query

Now that we have a basic understanding of how SQLite's query optimizer works,
let's take a look at a simple example query and see how it's optimized.

Borrowing from the Rice University legend, Dr. Christopher Jermaine, let's say
we have the following relational schema:

```sql

CREATE TABLE LIKES (
    DRINKER TEXT,
    BEER TEXT
);

-- Example data
INSERT INTO LIKES (DRINKER, BEER) VALUES
('Ava', 'Bud Light'),
('Ava', 'Pabst'),
('Ava', 'Miller Lite'),
('Bob', 'Bud Light'),
('Bob', 'Coors Light'),
('Bob', 'Miller Lite'),
('Charlie', 'Bud Light'),
('Charlie', 'Coors Light'),
('Charlie', 'Miller Lite');
```

For demonstration, I'll be using the
[SQLite Online Compiler](https://sqliteonline.com/) to run the queries. Suppose
we want to find all the beers that Ava likes with the following query:

```sql

SELECT BEER FROM LIKES WHERE DRINKER = 'Ava';
```

{{ responsive(
    src="run-simple.png",
    alt="Running the simple query",
    caption="Results of the simple query",
    width=80)
}}

As we can see, we get the expected results for this query. But how does SQLite's
query optimizer actually execute this query?

### Analyzing the Query: Breaking Down SQLite's Execution Process

#### 1. **Parsing the Query**

The first thing SQLite does is parse the SQL statement. The parser checks the
query for any syntax errors and builds a parse tree—a hierarchical
representation of the query. This step ensures that the SQL statement is valid
and prepares it for further processing.

#### 2. **Generating the Execution Plan**

After parsing, SQLite moves on to the query planning phase, where it generates
an execution plan. An execution plan is a step-by-step roadmap of how SQLite
will retrieve the data. This involves several key decisions:

{{note(body="

- **Table Access Method**: SQLite needs to decide how to access the `LIKES`
  table. Since the `WHERE` clause filters rows based on the `DRINKER` column,
  SQLite considers whether there's an index on `DRINKER` that can speed up the
  retrieval.

- **Index Usage**: If there were an index on the `DRINKER` column, SQLite might
  use it to directly look up rows where `DRINKER = 'Ava'`. However, in this
  case, there’s no such index, so SQLite will perform a **full table scan**.

")}}

We can inspect the execution plan using the `EXPLAIN QUERY PLAN` command:

```sql

-- Explain query plan
EXPLAIN QUERY PLAN
SELECT BEER FROM LIKES WHERE DRINKER = 'Ava';
```

As expected since there's no index on the `DRINKER` column, the output is:

```sql

SCAN LIKES
```

#### 3. **Full Table Scan Explained**

The plan indicates "SCAN LIKES," meaning SQLite will read through the entire
`LIKES` table, row by row, to find matches where `DRINKER = 'Ava'`. Here’s how
it works:

{{ note(body="

- SQLite starts at the first row of the `LIKES` table and checks if the
  `DRINKER` column equals 'Ava'.
- If it matches, SQLite includes the `BEER` column from that row in the result
  set.
- This process repeats for every row in the table.

") }}

Even though a full table scan is the least efficient method (especially with
large tables), it’s the only option when no suitable index is available. For
small tables like our example, the performance impact is minimal, but with
larger datasets, this could become a bottleneck.

#### 4. **Using Rowid Lookups for Efficiency**

While full table scans are sometimes necessary, SQLite often relies on **rowid
lookups** to speed up queries when no more specific index is available. Each
table in SQLite has a unique identifier for each row called the `rowid`. If your
query involves this `rowid` directly, SQLite can perform a binary search on this
identifier, which is significantly faster than a full table scan.

For example, consider the following query:

```sql

SELECT BEER FROM LIKES WHERE rowid = 1;
```

In this case, SQLite will directly use the rowid to locate the record, bypassing
the need to scan every row in the table. This technique can be particularly
useful when you know the specific `rowid` of the data you need to retrieve.

#### 5. **Execution: Returning the Results**

Once the execution plan is ready, SQLite moves to the execution phase. The
database engine follows the plan, scanning the `LIKES` table, filtering rows,
and collecting the `BEER` values where `DRINKER` is 'Ava'. The results are then
returned to the user.

In this simple case, the query returns:

{{ note(body="
Bud Light

Pabst

Miller Lite
")}}

These results match what we expected because the query is straightforward and
the table is small.

#### 6. **Optimizing the Query (The What-If Scenario)**

Let’s imagine we want to optimize this query. The most effective way would be
to create an index on the `DRINKER` column. With an index, SQLite could:

- **Skip the Full Table Scan**: Instead of scanning the entire table, SQLite
  could directly jump to the rows where `DRINKER = 'Ava'`, significantly
  speeding up the query.

Here’s how you could create the index:

```sql

CREATE INDEX idx_drinker ON LIKES(DRINKER);
```

With this index, if you run the same query again:

```sql

SELECT BEER FROM LIKES WHERE DRINKER = 'Ava';
```

SQLite would use the index to find all rows with `DRINKER = 'Ava'` directly,
reducing the amount of work it needs to do.

Now when we `EXPLAIN QUERY PLAN` command to inspect how SQLite would handle the
query now, we see:

```
SEARCH LIKES USING INDEX idx_drinker (DRINKER=?)
```

This indicates that SQLite is now using the `idx_drinker` index to perform a
much faster search. Instead of scanning the entire table, it quickly narrows
down the relevant rows using the index, demonstrating a significant improvement
in query performance.

#### Takeaways from the Simple Query Example

This simple example highlights how SQLite’s query optimizer works in the
background to execute SQL queries efficiently. While a full table scan might be
acceptable in small tables, as your data grows, understanding and utilizing
indexes can make a world of difference in performance.

Even in this simple query, we've uncovered the critical role the query planner
plays in determining how to retrieve your data efficiently, and how small
changes—like adding an index—can lead to significant performance gains.

In the next sections, we’ll dive deeper into more complex queries and see how
SQLite handles more challenging scenarios, giving you the tools to write even
more efficient SQL code.

---

## Complex Query Example: Getting to the Heart of the Optimizer

Now that we’ve covered the basics, let’s look at a more complicated query that
gives SQLite’s optimizer something to chew on.

Imagine we have two tables, `DRINKER` and `BEER`, and we want to perform a query
that joins them to find out which beers each drinker likes, sorted by their
preference. The schema might look something like this:

```sql

CREATE TABLE DRINKER (
    ID INTEGER PRIMARY KEY,
    NAME TEXT
);

CREATE TABLE BEER (
    ID INTEGER PRIMARY KEY,
    NAME TEXT,
    TYPE TEXT
);

CREATE TABLE LIKES (
    DRINKER_ID INTEGER,
    BEER_ID INTEGER,
    PREFERENCE INTEGER, -- Lower numbers indicate higher preference
    FOREIGN KEY(DRINKER_ID) REFERENCES DRINKER(ID),
    FOREIGN KEY(BEER_ID) REFERENCES BEER(ID)
);
```

And let's populate the tables with some example data:

```sql

-- Example data
INSERT INTO DRINKER (ID, NAME) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

INSERT INTO BEER (ID, NAME, TYPE) VALUES
(1, 'Budweiser', 'Lager'),
(2, 'Coors Light', 'Lager'),
(3, 'Miller Lite', 'Pilsner');

INSERT INTO LIKES (DRINKER_ID, BEER_ID, PREFERENCE) VALUES
(1, 1, 1),  -- Alice likes Budweiser the most
(1, 2, 2),  -- Alice likes Coors Light second
(2, 3, 1),  -- Bob prefers Miller Lite
(3, 1, 1),  -- Charlie likes Budweiser the most
(3, 2, 3),  -- Charlie's least favorite is Coors Light
(3, 3, 2);  -- Charlie likes Miller Lite second
```

Now, suppose we want to find out which beers each drinker likes, sorted by their
preference:

```sql

SELECT DRINKER.NAME, BEER.NAME, LIKES.PREFERENCE
FROM DRINKER
JOIN LIKES ON DRINKER.ID = LIKES.DRINKER_ID
JOIN BEER ON BEER.ID = LIKES.BEER_ID
ORDER BY DRINKER.NAME, LIKES.PREFERENCE;
```

This query isn’t as simple as it looks. SQLite’s optimizer has to decide:

1. **Join Order**: Should it start with the `DRINKER`, `LIKES`, or `BEER` table?
2. **Index Usage**: Which indexes, if any, can be used to speed up the joins
   and the sorting?
3. **Sorting**: How should the results be sorted efficiently after the joins?

### Understanding the Query Plan: What Happens Behind the Scenes

When we look at the query plan for the complex query:

```sql

EXPLAIN QUERY PLAN
SELECT DRINKER.NAME, BEER.NAME, LIKES.PREFERENCE
FROM DRINKER
JOIN LIKES ON DRINKER.ID = LIKES.DRINKER_ID
JOIN BEER ON BEER.ID = LIKES.BEER_ID
ORDER BY DRINKER.NAME, LIKES.PREFERENCE;
```

We get the following output:

{{ note(body="
SCAN LIKES

SEARCH DRINKER USING INTEGER PRIMARY KEY (rowid=?)

SEARCH BEER USING INTEGER PRIMARY KEY (rowid=?)

USE TEMP B-TREE FOR ORDER BY

")}}

This output provides a high-level overview of how SQLite intends to execute the
query. Let’s break down each component and understand what’s happening under the
hood.

#### 1. **Scan the `LIKES` Table**

- **Plan Step**: `SCAN LIKES`

SQLite begins by scanning the `LIKES` table. Since `LIKES` is the central table
in this query, containing the foreign keys that link `DRINKER` to `BEER`, it
makes sense for SQLite to start here.

- **Why a Table Scan?**: The plan shows that SQLite performs a full table scan
  on `LIKES`, meaning it reads every row in the table. This might seem
  inefficient, but without specific indexes on `DRINKER_ID` or `BEER_ID`, a
  full scan is necessary to gather all the relevant data.

#### 2. **Searching the `DRINKER` and `BEER` Tables**

{{ note(body="

- **Plan Steps**:
  - `SEARCH DRINKER USING INTEGER PRIMARY KEY (rowid=?)`
  - `SEARCH BEER USING INTEGER PRIMARY KEY (rowid=?)`

")}}

For each row in `LIKES`, SQLite needs to find the corresponding `DRINKER` and
`BEER` entries. It uses the primary key indexes (`INTEGER PRIMARY KEY`) on
these tables to quickly locate the matching rows.

- **Primary Key Lookup**: Because both `DRINKER.ID` and `BEER.ID` are defined
  as primary keys, SQLite can perform an efficient lookup using these
  indexes. The query plan indicates that for each `LIKES` entry, SQLite
  performs a quick search in both `DRINKER` and `BEER` tables to retrieve the
  `NAME` fields.

#### 3. **Using a Temporary B-Tree for Sorting**

- **Plan Step**: `USE TEMP B-TREE FOR ORDER BY`

The final step in the query plan involves sorting the results. The query
requests that the results be ordered by `DRINKER.NAME` and `LIKES.PREFERENCE`.
Since the data isn’t naturally ordered in this way, SQLite must perform
additional work to achieve this sort order.

- **Temporary B-Tree**: To sort the results efficiently, SQLite creates a
  temporary B-tree structure. A B-tree is a self-balancing tree data
  structure that maintains sorted data and allows for efficient insertion,
  deletion, and lookup operations. By inserting the result set into this B-
  tree, SQLite can quickly and efficiently retrieve the data in the desired order.

- **Why Not an Index?**: The need for a temporary B-tree indicates that there
  isn’t an existing index that supports the required sort order. This extra
  step adds overhead, which is why creating an appropriate index can be beneficial.

Combining all these steps, we get the expected output:

{{ responsive(
    src="run-complex.png",
    alt="Running the complex query",
    caption="Results of the complex query",
    width=80)
}}

<br>

### Optimizing the Query: Adding a Multi-Column Index

As mentioned earlier, one way to improve this query's performance is by adding
an index on the `LIKES` table. Specifically, creating a **multi-column
index** on the combination of `DRINKER_ID` and `PREFERENCE` would directly
support the sorting required by the query:

```sql

CREATE INDEX idx_likes_drinker_pref ON LIKES(DRINKER_ID, PREFERENCE);
```

By creating this multi-column index, SQLite can:

- **Avoid Full Table Scans**: With this index, SQLite can avoid a full scan
  of the `LIKES` table. Instead, it can directly jump to the relevant rows
  using the index, which is more efficient.

- **Optimize Sorting**: The index also covers the `PREFERENCE` column, which
  means the results can be retrieved in the correct order directly from the
  index. This eliminates the need for a temporary B-tree, reducing the
  query’s overall execution time.

{{ responsive(
    src="multicolumn-idx.png",
    alt="Example multicolumn index from the SQLite query planner documentation
    illustrating a lookup using the index",
    caption="Example multicolumn index from the SQLite query planner
        documentation illustrating a lookup using the index.",
    width=80
) }}

### Re-running the Query Plan

After creating the index, if we re-run the `EXPLAIN QUERY PLAN` command, we
might see a different plan:

```sql

EXPLAIN QUERY PLAN
SELECT DRINKER.NAME, BEER.NAME, LIKES.PREFERENCE
FROM DRINKER
JOIN LIKES ON DRINKER.ID = LIKES.DRINKER_ID
JOIN BEER ON BEER.ID = LIKES.BEER_ID
ORDER BY DRINKER.NAME, LIKES.PREFERENCE;
```

The updated plan now reflects the use of the new index:

{{ note(body="
SCAN DRINKER
SEARCH LIKES USING INDEX idx_likes_drinker_pref (DRINKER_ID=?)
SEARCH BEER USING INTEGER PRIMARY KEY (rowid=?)
USE TEMP B-TREE FOR ORDER BY

")}}

This new execution plan reflects several optimizations made by SQLite:

1. **SCAN DRINKER**:

   - SQLite starts by scanning the `DRINKER` table. Since this is a full
     table scan, it reads each row from the `DRINKER` table sequentially.
     This step makes sense as it’s the starting point of our query, and no
     filters or constraints are applied to `DRINKER` that would allow an
     index to be used here.

2. **SEARCH LIKES USING INDEX `idx_likes_drinker_pref` (DRINKER_ID=?)**:

   - Here’s where the optimization kicks in. SQLite uses the newly created
     index `idx_likes_drinker_pref` on the `LIKES` table. This index is likely
     created on the `DRINKER_ID` and `PREFERENCE` columns, allowing SQLite to
     efficiently find the rows in `LIKES` where `DRINKER_ID` matches the
     current row from the `DRINKER` table. This dramatically reduces the amount
     of data SQLite needs to sift through compared to a full table scan.

3. **SEARCH BEER USING INTEGER PRIMARY KEY (rowid=?)**:

- For the `BEER` table, SQLite utilizes the primary key index, which is an
  automatically created index on the `ID` column (which acts as the `rowid`).
  Since this is the most efficient way to retrieve specific rows from `BEER`,
  SQLite uses this index to quickly find the beer names corresponding to the
  `BEER_ID` values from the `LIKES` table.

4. **USE TEMP B-TREE FOR ORDER BY**:
   - Finally, SQLite notes that it will use a temporary B-Tree to sort the
     results according to the `ORDER BY` clause (`DRINKER.NAME` and
     `LIKES.PREFERENCE`). Even though indexes can often help with sorting, in
     this case, SQLite decides to use a temporary B-Tree structure to ensure
     that the results are returned in the correct order. This step can be a bit
     more resource-intensive, but it guarantees that the results will be sorted
     as requested.

The use of the `idx_likes_drinker_pref` index significantly improves the
efficiency of the query. By avoiding a full table scan on `LIKES`, SQLite
reduces the amount of data it needs to process, which speeds up query
execution, especially on larger datasets.

The final `ORDER BY` clause requires SQLite to sort the results, and since
the current indexes do not cover both `DRINKER.NAME` and `LIKES.PREFERENCE`,
SQLite opts to use a temporary B-Tree. If you frequently run this query and
notice the sorting step is a bottleneck, you could consider creating a
composite index on these two columns to further optimize performance.

---

## Conclusion: Tips for Writing Efficient Queries

By peeking under the hood at how SQL queries are executed, you can gain some
intuition on why certain queries are faster than others. Here are a few tips
to keep in mind:

1. **Index Your Foreign Keys**: Always create indexes on columns used in
   `JOIN` conditions. This speeds up the process of matching rows between tables.

2. **Use Covering Indexes**: If possible, create indexes that cover all the
   columns your query needs, so SQLite doesn’t need to access the main table
   at all.

3. **Write Selective WHERE Clauses**: If your `WHERE` clause can quickly
   eliminate rows from consideration, your query will run faster. The fewer rows
   SQLite has to process, the better.

4. **Avoid Redundant Sorting**: If you know your data is already sorted in
   the way you want, avoid using `ORDER BY`. It just adds unnecessary processing
   time.

5. **Optimize Subqueries**: Subqueries can sometimes be rewritten as joins,
   which might be more efficient, especially if the subquery’s result set is
   large.

6. **Understand the Query Planner**: Use tools like `EXPLAIN QUERY PLAN` to
   understand how SQLite executes your queries. Sometimes, a small change in the
   query structure can lead to a big performance improvement.

Learning to write efficient SQL queries is a valuable skill that translates
across all database systems and can make a significant difference in your
application’s performance, scalability, and resource usage. Like most things,
it takes practice and experimentation and this post just scratches the
surface of optimizing queries. If you have any tips or tricks for optimizing
SQL queries, feel free to share them in the comments!

## References

- [Full SQL Script for the Examples](https://gist.github.com/micahkepe/f9035bf308510b11482d1643b07ceaf7)
- [The SQLite Query Optimizer Overview](https://www.sqlite.org/optoverview.html)
- [SQLite Query Planner](https://www.sqlite.org/queryplanner.html)
- [The Next-Generation Query Planner](https://www.sqlite.org/queryplanner-ng.html)
- [Order of Execution of SQL Queries](https://www.geeksforgeeks.org/order-of-execution-of-sql-queries/)

{{ giscus() }}

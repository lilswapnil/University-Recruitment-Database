
# 🎓 University Recruitment Database (ERP Prototype)

<p align="center">
  <img src="assets/diagram/diagram-1.png" alt="System diagram: University Recruitment Admissions pipeline" width="600">
  <br/>
  <em>High-level flow of the Oracle Admissions (banner-like) → SQL Server Warehouse ETL pipeline.</em>
</p>

## 📖 Overview

This project demonstrates a **University Recruitment ERP prototype** that integrates **OracleDB (PL/SQL)** admissions data with a **SQL Server (T-SQL)** data warehouse using **Dockerized containers**.

It’s designed to showcase skills in:

- **SQL Server**: dimensional modeling, stored procedures, triggers, candidate ranking  
- **Oracle Database + PL/SQL**: schema design, packages, staging/publish mechanism  
- **Docker**: reproducible multi-DB environment (SQL Server Edge for ARM, Oracle XE 21c)  
- **Cross-DB ETL**: pulling deltas from Oracle into SQL Server for analytics  

---

## ⚙️ Features

- **Oracle Admissions (banner-like)**  
  Schema + sample data + PL/SQL package to publish application deltas  

- **SQL Server Data Warehouse**  
  Dimensional model, audit triggers, ranking procedure  

- **Python ETL**  
  Loads Oracle staging deltas into SQL Server  

- **Containerized Environment**  
  Oracle XE 21c + Azure SQL Edge (ARM) + Adminer  

---

## 🚀 Quickstart (Makefile commands)

```bash
make up       # start containers (Oracle + SQL Server + Adminer)
make init     # initialize SQL Server schema
make seed     # publish Oracle demo data
make etl      # run Python ETL (load + transform + rank)
make rank     # query candidate rankings from SQL Server
make down     # stop containers
make clean    # nuke containers, images, volumes
````

✅ After `make etl`, you should see:

```text
Candidate Scores:
(2002, 'Asha', 'Patel', 95)
(2001, 'Linh', 'Nguyen', 60)
```

---

## 📊 Example Output in SQL Server

```bash
make rank
```

Output:

```text
pidm  first_name  last_name  score
2002  Asha        Patel      95
2001  Linh        Nguyen     60
```

---

## 🛠️ Tech Stack

* **SQL Server / Azure SQL Edge**
* **Oracle Database XE 21c**
* **PL/SQL** (packages, procs, staging)
* **T-SQL** (warehouse schema, ETL, triggers, ranking)
* **Docker Compose**
* **Python** (`pyodbc`, `oracledb`)

---

## 📝 Notes

* Use **Azure SQL Edge** instead of `mssql/server` on Apple Silicon.
* Oracle XE requires ≥4 GB memory (6–8 GB recommended).
* For simplicity, ETL runs via Python. SQL Server Linked Server scripts are included as references.

````

---

# 📝 Updated `GETTING_STARTED.md`

```markdown
# 🚀 Getting Started After Cloning

Welcome to the **University Recruitment Database (ERP Prototype)**.  
Follow these steps to bring the system up after cloning.

---

## 1. Clone the Repository

```bash
git clone https://github.com/<your-username>/University-Recruitment-Database.git
cd University-Recruitment-Database
````

---

## 2. Prerequisites

* **Docker Desktop** (Mac/Windows/Linux)

  * On Apple Silicon: allocate ≥6 GB memory in Docker Desktop → Settings → Resources
* **Python 3.10+** with `pip`
* **Make** (comes with macOS and Linux; on Windows, use WSL or Git Bash)

---

## 3. One-Command Workflow

Use the provided `Makefile` to simplify everything:

```bash
make up       # start containers
make init     # create SQL Server schema
make seed     # publish Oracle demo data
make etl      # run Python ETL (loads into SQL Server)
make rank     # query candidate rankings
```

---

## 4. Explore with Adminer

Visit [http://localhost:8080](http://localhost:8080)

* **SQL Server**

  * System: MS SQL
  * Server: uni-mssql
  * User: sa
  * Password: SqlServerP\@ssw0rd!
  * Database: university\_recruitment

* **Oracle**

  * System: Oracle
  * Server: uni-oracle:1521
  * User: admissions
  * Password: AdmissionsP\@ssw0rd
  * Service: XEPDB1

---

## 5. Stopping & Cleanup

```bash
make down     # stop containers
make clean    # remove containers, images, volumes
```

---

## ✅ Expected Results

After running `make etl`, you should see:

```
Candidate Scores:
(2002, 'Asha', 'Patel', 95)
(2001, 'Linh', 'Nguyen', 60)
```

---

## 🎯 Next Steps

* Extend schema with more recruitment modules
* Add BI dashboards (Power BI, Streamlit, etc.)
* Automate ETL tests with GitHub Actions

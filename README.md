
# 🚀 Getting Started After Cloning

Welcome to the **University Recruitment Database (ERP Prototype)**.  
This guide walks you through everything you need to do after cloning the repository.

---

## 📂 1. Clone the Repository

```bash
git clone https://github.com/<your-username>/University-Recruitment-Database.git
cd University-Recruitment-Database
````

---

## 🐳 2. Prerequisites

* **Docker Desktop** (macOS/Windows/Linux)

  * On Apple Silicon (M1/M2/M3), enable at least **6–8 GB memory** in Docker Desktop → Settings → Resources.
* **Python 3.10+** with `pip`
* (Optional) **Make** if you want shorter commands via a Makefile.

---

## 📦 3. Start the Containers

From the `integrations` folder:

```bash
cd integrations
docker compose up -d
```

👉 Services that come up:

* `uni-oracle`: Oracle XE 21c (admissions system, seeded with demo data)
* `uni-mssql`: Azure SQL Edge (SQL Server-compatible warehouse)
* `adminer`: Adminer DB UI ([http://localhost:8080](http://localhost:8080))

Check containers:

```bash
docker ps
```

---

## 🗄️ 4. Initialize SQL Server Schema

Run the SQL Server schema script via the `mssql-tools` image:

```bash
docker run --rm -it \
  --add-host=host.docker.internal:host-gateway \
  -v "$(pwd)/sqlserver/init:/scripts" \
  mcr.microsoft.com/mssql-tools \
  /opt/mssql-tools18/bin/sqlcmd -C -S host.docker.internal -U sa -P "SqlServerP@ssw0rd!" \
  -i /scripts/01_create_db.sql
```

---

## 📤 5. Publish Demo Data in Oracle

Run the PL/SQL package to publish deltas to staging:

```bash
docker exec -it uni-oracle bash -lc \
"sqlplus -s admissions/AdmissionsP@ssw0rd@localhost/XEPDB1 @/container-entrypoint-initdb.d/03_publish_demo.sql"
```

---

## 🐍 6. Run ETL with Python

Set up Python environment and install dependencies:

```bash
python -m venv venv
source venv/bin/activate    # On macOS/Linux
pip install -r integrations/requirements.txt
```

Run ETL:

```bash
python integrations/etl_oracle_to_sqlserver.py
```

✅ Expected output:

```
Candidate Scores:
(2002, 'Asha', 'Patel', 95)
(2001, 'Linh', 'Nguyen', 60)
```

---

## 🌐 7. Explore with Adminer

Visit [http://localhost:8080](http://localhost:8080) in your browser.

* **System:** MS SQL
  **Server:** uni-mssql
  **User:** sa
  **Password:** SqlServerP\@ssw0rd!
  **Database:** university\_recruitment

* **System:** Oracle
  **Server:** uni-oracle:1521
  **User:** admissions
  **Password:** AdmissionsP\@ssw0rd
  **SID/Service:** XEPDB1

---

## 🛠️ 8. Useful Commands

Stop everything:

```bash
docker compose down
```

Restart:

```bash
docker compose up -d
```

Clean up:

```bash
docker system prune -af
```

---

## 📝 Notes

* Use **Azure SQL Edge** instead of `mssql/server` on Apple Silicon.
* Oracle XE container requires enough memory (≥4 GB, ideally 6–8 GB).
* For production-style ETL, you can extend with SQL Server Linked Server or CI/CD automation.

---

## 🎯 Next Steps

* Extend schema with more recruitment modules
* Add dashboards (e.g., Power BI, Streamlit, or React frontend)
* Automate tests with GitHub Actions

````

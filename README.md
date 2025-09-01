
# 🎓 University Recruitment Database

<p align="center">
  <img src="assets/diagram.png" alt="System diagram: University Recruitment Data Visualization Flow" width="500">
  <br/>
  <em>High-level flow of the recruitment data analysis and visualization pipeline.</em>
</p>

---

## 📖 Overview
The **University Recruitment Database** project analyzes and visualizes key aspects of university data, including student enrollments, instructor distribution, salary structures, and tuition patterns.  

Using **Python (Jupyter Notebook)** and **SQL**, the project transforms raw institutional data into meaningful insights that support data-driven decision-making.

---

## ✨ Features
- **Student Enrollment Trends** (monthly bar chart)  
- **Instructor Salary Distribution** (histogram)  
- **Course Enrollment Distribution** (bar chart)  
- **Department-wise Instructor Count** (bar chart)  
- **Tuition vs. Course Units Analysis** (scatter plot)  
- Interactive visualizations built with `matplotlib` and `pandas`  

---

## 🗂️ Repository Structure
```

University-Recruitment-Database/
│── Notebook.ipynb           # Main Jupyter notebook for visualizations
│── UMC.sql                  # SQL schema / queries for university database
│── business\_reports.sql      # Additional reporting queries
│── README.md                 # Project documentation
│── assets/diagram.png        # System flow diagram

````

---

## ⚙️ Prerequisites
- Python **3.x**
- Jupyter Notebook
- Libraries:
  - `pandas`
  - `numpy`
  - `matplotlib`

Install dependencies:
```bash
pip install pandas numpy matplotlib
````

---

## 🚀 Getting Started

1. **Clone the repository**

   ```bash
   git clone https://github.com/lilswapnil/University-Recruitment-Database.git
   cd University-Recruitment-Database
   ```

2. **Set up the database**

   * Run `UMC.sql` to create the schema.
   * Use `business_reports.sql` for reporting queries.

3. **Launch the notebook**

   ```bash
   jupyter notebook Notebook.ipynb
   ```

   Update the connection string or load CSV data if required.

4. **View results**

   * Run cells in the notebook to generate the visualizations.

---

## 📊 Sample Visualization

Example: **Student Enrollment Trend**

```python
import matplotlib.pyplot as plt

months = ["Jan", "Feb", "Mar", "Apr", "May"]
enrollments = [120, 135, 150, 160, 145]

plt.bar(months, enrollments, color="skyblue")
plt.title("Monthly Student Enrollment Trend")
plt.xlabel("Month")
plt.ylabel("Enrollment Count")
plt.show()
```

---

## 👨‍💻 Contributors

* **Scott B.**
* **Shreya Bandodkar**

---

## 📜 License

This project is licensed under the **MIT License** – see the [LICENSE](LICENSE) file for details.

---

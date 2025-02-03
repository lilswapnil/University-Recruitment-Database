# University-Recruitment-Database

# Data Visualization for University Recruitment Database

## Overview
This project provides visualizations for key aspects of the University Recruitment Database. The visualizations help analyze student enrollments, instructor salaries, course enrollments, department-wise instructor distribution, and tuition vs. course units. The data is sourced from SQL queries that retrieve relevant records from the database.

## Features
- **Student Enrollment Trends**: A bar chart displaying the number of students enrolled each month.
- **Instructor Salary Distribution**: A histogram representing the distribution of instructor salaries.
- **Course Enrollment Distribution**: A bar chart showcasing the number of students enrolled per course.
- **Department-Wise Instructor Count**: A bar chart displaying the number of instructors in each department.
- **Tuition and Course Units Analysis**: A scatter plot correlating course units with tuition fees.

## Prerequisites
Ensure you have the following installed:
- Python 3.x
- `matplotlib` for visualization (`pip install matplotlib`)
- `pandas` for data manipulation (`pip install pandas`)
- `numpy` for numerical computations (`pip install numpy`)

## How to Run
1. Clone the repository or download the project files.
2. Ensure you have a dataset (either a database connection or a CSV file with the required data).
3. Modify the script to read the actual data from the database or CSV.
4. Run the Python script:
   ```sh
   python visualize_data.py
   ```
5. The plots will be displayed one by one for analysis.

## Example Code
```python
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

# Sample Data (Replace with actual data from your database or CSV)
students_data = pd.DataFrame({
    'EnrollmentDate': pd.date_range(start='2022-01-01', periods=10, freq='M'),
    'StudentCount': np.random.randint(50, 200, 10)
})

# Visualization 1: Student Enrollment Trends
plt.figure(figsize=(10, 5))
plt.bar(students_data['EnrollmentDate'].dt.strftime('%b %Y'), students_data['StudentCount'], color='skyblue')
plt.xlabel('Enrollment Month')
plt.ylabel('Number of Students')
plt.title('Student Enrollment Trends')
plt.xticks(rotation=45)
plt.show()
```

## Data Sources
The data used in this project is derived from structured SQL queries in the University Recruitment Database.

## License
This project is open-source and available under the MIT License.

## Contributors
- Scott B
- Shreya Bandodkar

## Contact
For questions or contributions, reach out to [Your Email].


## 🛠 System Prerequisites

Ensure the following environments and applications are deployed before initialization:
* **Python:** Version `3.9` or higher.
* **MySQL Server:** Version `8.0` or higher (configured on local port `3306`).
* **MySQL Workbench:** Recommended administration console for script execution and schema validation.

---

## 🚀 Step-by-Step Installation & Setup

### Step 1: Initialize the Application Workspace
Open your preferred terminal console (Command Prompt, PowerShell, or Git Bash) and navigate into your root project directory:
```bash
cd C:\Users\PC\dbms_project
###Step 2: Establish an Isolated Environment (Virtual Environment)
Isolate your package dependencies to avoid environmental namespace collisions:

Bash
# Generate the virtual environment binaries
python -m venv .venv

# Activate the virtual environment workspace (Windows PowerShell)
.\.venv\Scripts\Activate.ps1
Note: Successful activation is confirmed by the active target indicator (.venv) prepended to your console input prompt line.

Step 3: Package Dependencies Installation
Deploy all external application requirements bundled through the Python Package Index using pip:

Bash
pip install -r requirements.txt
Step 4: Configure the Relational Storage Engine (MySQL Setup)
Launch MySQL Workbench and authenticate into your local server instance.

Open and execute the database structural script shopdb.sql. This initializes the targeted schema, basic relational arrays (INVOICE, LINE, PRODUCT, CUSTOMER, EMPLOYEE), transactional triggers, and functional Stored Procedures (CANCEL_INVOICE, DELETE_LINE, UPDATE_UNITS, PAY_INVOICE_BANK, PAY_INVOICE_CASH).

Verify that your localized application database controller configurations (host, user, password, database) correspond exactly with your regional MySQL server credentials.

💻 Running the Application
Execute the centralized program bootstrap entry point while maintaining an active environmental container:

Bash
python main.py
dbms_project/
├── .venv/                  # Python isolated dependencies workspace
├── main.py                 # Core application bootstrap orchestration and UI loop
├── GUI.py                  # CustomTkinter interface layout layout definitions
├── db_mgr.py               # Database manager handler mapping transactional procedure calls
├── utils.py                # Specialized data formatting and currency processing helpers
├── shopdb.sql              # Core SQL script declaring tables, triggers, and procedure assets
├── requirements.txt        # Tracked production environment software packages
└── README.md               # Complete architectural overview and deployment guide
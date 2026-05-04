import streamlit as st
import pandas as pd
import os
from db_manager import get_db
from crud_logic import *
from logger import log_system_activity

# --- 1. UI CONFIGURATION (Pink Pastel & Times New Roman) ---
st.set_page_config(page_title="NEU Pink Sales Management", layout="wide")

st.markdown("""
    <style>
    @import url('https://fonts.googleapis.com/css2?family=Times+New+Roman&display=swap');
    
    html, body, [class*="css"] {
        font-family: 'Times New Roman', Times, serif !important;
        background-color: #FFF0F5; /* Lavender Blush */
    }
    .stButton>button {
        background-color: #FFB6C1; /* Light Pink */
        color: white; border-radius: 8px; border: none;
        font-weight: bold;
    }
    .stSidebar {
        background-color: #FFC0CB !important; /* Pink */
    }
    h1, h2, h3 { color: #DB7093 !important; } /* Pale Violet Red */
    .stMetric {
        background-color: white;
        padding: 15px;
        border-radius: 10px;
        box-shadow: 2px 2px 5px rgba(0,0,0,0.1);
    }
    </style>
    """, unsafe_allow_html=True)

# --- 2. LOGIN LOGIC (Based on account: jones3 & sanchez4) ---
if 'logged_in' not in st.session_state:
    st.session_state.logged_in = False

if not st.session_state.logged_in:
    st.title("💖 NEU Sales System Login")
    with st.container():
        user = st.text_input("Username")
        pwd = st.text_input("Password", type="password")
        if st.button("Sign In"):
            # Credentials from the team discussion
            if (user == "jones3" and pwd == "123password") or (user == "sanchez4" and pwd == "456password"):
                st.session_state.logged_in = True
                st.session_state.role = "Manager" if user == "sanchez4" else "Staff"
                st.session_state.username = user
                st.success(f"Welcome back, {user}!")
                st.rerun()
            else:
                st.error("Invalid credentials. Please try again.")
else:
    # --- 3. MAIN INTERFACE ---
    st.sidebar.title(f"🌸 Welcome, {st.session_state.username}!")
    st.sidebar.write(f"Role: **{st.session_state.role}**")
    
    # Tabs Authorization Logic
    tabs_list = ["📦 Inventory", "👤 Customers", "🧾 Invoices"]
    if st.session_state.role == "Manager":
        tabs_list += ["👥 Employees", "📊 Dashboard", "📜 System Logs"]
    
    choice = st.sidebar.radio("Navigation Menu", tabs_list)
    db = next(get_db())

    # --- 4. TABS CONTENT ---
    
    if "Inventory" in choice:
        st.header("Product Inventory Management")
        search_kw = st.text_input("Search Product Description")
        if st.button("Search"):
            results = search_products(db, search_kw)
            if results:
                st.dataframe(pd.DataFrame(results), use_container_width=True)
                log_system_activity(st.session_state.username, "SEARCH", f"Keyword: {search_kw}")
            else:
                st.warning("No products found.")
            
        if st.session_state.role == "Manager":
            st.divider()
            st.subheader("🛠️ Quick Stock Update")
            with st.container():
                p_code = st.number_input("Product Code", min_value=1)
                units = st.number_input("Add Units", min_value=1)
                if st.button("Confirm Restock"):
                    add_stock_units(db, p_code, units)
                    st.success(f"Added {units} units to Product {p_code}")
                    log_system_activity(st.session_state.username, "RESTOCK", f"P_CODE: {p_code}, QTY: {units}")

    elif "Customers" in choice:
        st.header("Customer Management")
        c_id = st.number_input("Customer ID", min_value=1)
        if st.button("View Details"):
            # Calls procedure with secret key hidden in crud_logic
            details = get_customer_details(db, c_id)
            if details:
                st.json(details._asdict())
                log_system_activity(st.session_state.username, "VIEW_CUSTOMER", f"ID: {c_id}")
            else:
                st.error("Customer not found.")

    elif "Dashboard" in choice and st.session_state.role == "Manager":
        st.header("Business Analytics Dashboard")
        report_data = get_customer_report(db) 
        if report_data:
            df = pd.DataFrame(report_data)
        
        # Metrics Row - Cập nhật tên cột TOTAL_SPENDING
            m1, m2, m3 = st.columns(3)
            m1.metric("Total Customers", len(df))
            m2.metric("Total Revenue", f"${df['TOTAL_SPENDING'].sum():,.2f}")
            m3.metric("Avg Spending", f"${df['TOTAL_SPENDING'].mean():,.2f}")
        
            st.divider()
        
        # Charts Row - Cập nhật tên cột TOTAL_SPENDING để vẽ biểu đồ
            c1, c2 = st.columns(2)
            with c1:
                st.subheader("Spending by Customer")
            # Trục Y sử dụng TOTAL_SPENDING
                st.bar_chart(df.set_index('CUS_LNAME')['TOTAL_SPENDING'])
            with c2:
                st.subheader("Detailed Report")
                st.dataframe(df, use_container_width=True)
        
    elif "Employees" in choice and st.session_state.role == "Manager":
        st.header("Employee Directory (Manager Only)")
        st.info("Phone numbers are decrypted using the System Secret Key.")
        employees = get_employee_list(db)
        if employees:
            st.dataframe(pd.DataFrame(employees), use_container_width=True)
            log_system_activity(st.session_state.username, "VIEW_EMPLOYEES", "Accessed directory")

    elif "System Logs" in choice and st.session_state.role == "Manager":
        st.header("Administrative Audit Trail")
        if os.path.exists("system_activity.log"):
            with open("system_activity.log", "r", encoding="utf-8") as f:
                st.text_area("Activity History", f.read(), height=400)
        
    if st.sidebar.button("Logout"):
        st.session_state.logged_in = False
        st.rerun()

    elif "Invoices" in choice:
        st.header("🧾 Invoice Management")
        st.subheader("Create New Order")
    
        with st.expander("Click to open Invoice Form"):
            col1, col2 = st.columns(2)
            with col1:
                c_id = st.number_input("Customer ID", min_value=1, step=1, key="cus_id_input")
            with col2:
                e_id = st.number_input("Employee ID", min_value=1, step=1, key="emp_id_input")
        
        # Chỉ thực hiện khi nhấn nút
            if st.button("Generate Invoice", key="gen_inv_btn"):
                try:
                # Gọi hàm xử lý
                    new_invoice = create_order(db, c_id, e_id)
                
                    if new_invoice:
                        st.success("Invoice generated successfully!")
                        st.write(new_invoice)
                    # Ghi log (Nhiệm vụ M3)
                        log_system_activity(st.session_state.username, "CREATE_INVOICE", f"Cus: {c_id}, Emp: {e_id}")
                except Exception as e:
                    st.error(f"Please try again: {str(e)}")
                    db.rollback()
                    
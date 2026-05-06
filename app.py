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
        font-weight: bold; width: 100%;
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

# --- 2. LOGIN LOGIC ---
if 'logged_in' not in st.session_state:
    st.session_state.logged_in = False

if not st.session_state.logged_in:
    st.title("💖 Sales System Login")
    with st.container():
        user = st.text_input("Username")
        pwd = st.text_input("Password", type="password")
        if st.button("Sign In"):
            # Credential check based on your team's provided data
            if (user == "jones3" and pwd == "123password") or (user == "sanchez4" and pwd == "456password"):
                st.session_state.logged_in = True
                st.session_state.role = "Manager" if user == "sanchez4" else "Staff"
                st.session_state.username = user
                st.success(f"Welcome back, {user}!")
                st.rerun()
            else:
                st.error("Invalid username or password!")
else:
    # --- 3. MAIN INTERFACE ---
    st.sidebar.title(f"🌸 Hi, {st.session_state.username}!")
    st.sidebar.write(f"Role: **{st.session_state.role}**")
    
    # Navigation logic based on role
    tabs_list = ["📦 Inventory", "👤 Customers", "🧾 Invoices", "📜 Order History"]
    if st.session_state.role == "Manager":
        tabs_list += ["👥 Employees", "📊 Analytics", "📜 System Logs"]
    
    choice = st.sidebar.radio("Navigation Menu", tabs_list)
    db = next(get_db())

    # --- 4. TAB CONTENT ---
    
    # --- INVENTORY TAB ---
    if "Inventory" in choice:
        st.header("Product Inventory Management")
        search_kw = st.text_input("Search Product by Description")
        if st.button("Search"):
            results = search_products(db, search_kw) #
            if results:
                st.dataframe(pd.DataFrame(results), use_container_width=True)
            else:
                st.warning("No products found matching that description.")

    # --- CUSTOMERS TAB ---
    elif "Customers" in choice:
        st.header("👤 Customer Directory")

    # --- THANH TÌM KIẾM ---
        search_term = st.text_input("🔍 Search customers by Last Name", placeholder="Enter name to filter...")

    # --- LẤY DỮ LIỆU ---
    # Khi search_term thay đổi, Streamlit sẽ tự chạy lại và cập nhật list
        customer_list = get_all_customers_full(db, search_term)

        if customer_list:
            st.subheader(f"Found {len(customer_list)} Customers")
        
        # Chuyển dữ liệu sang DataFrame để hiển thị bảng đẹp hơn
            df_customers = pd.DataFrame(customer_list)
        
        # Hiển thị bảng với chiều rộng tự điều chỉnh
            st.dataframe(df_customers, use_container_width=True, hide_index=True)
        
        # Thêm tính năng xem chi tiết nhanh khi chọn ID
            st.divider()
            with st.expander("Quick Inspect Customer"):
                c_id = st.number_input("Enter ID to see raw JSON", min_value=1, step=1)
                if st.button("Inspect"):
                    details = get_customer_details(db, c_id) # Dùng lại hàm cũ của An
                    if details:
                        st.json(details)
                    else:
                        st.error("Customer not found.")
        else:
            st.info("No customers found matching your search.")

    # Mẹo: Khi An thêm khách mới ở tab Invoices, 
    # tab này sẽ tự động cập nhật vì nó luôn gọi lại get_all_customers_full mỗi khi load.
    # --- INVOICES TAB ---
    elif choice == "🧾 Invoices":
        # Trong phần tab Invoices
        st.header("🛒 Create New Sale Invoice")

# Dùng columns để giao diện gọn gàng
        col1, col2 = st.columns(2)

        with col1:
    # Thêm tham số key='inv_customer_name' để tránh trùng ID
            full_name = st.text_input("Customer Name", key="inv_customer_name")
            phone = st.text_input("Phone Number", key="inv_phone")

        with col2:
            is_new = st.checkbox("New Customer?", key="inv_is_new")
            if not is_new:
        # Nếu là khách cũ thì nhập ID
                cus_id = st.number_input("Customer ID (Existing)", min_value=1, step=1, key="inv_cus_id")
            else:
                cus_id = None
    
    # --- PHẦN 2: CHI TIẾT GIỎ HÀNG ---
    # Giả sử An đã có danh sách sản phẩm lấy từ DB
        products = get_all_products(db) # Hàm lấy danh sách SP của An
        product_options = {p['P_DESCRIPT']: p for p in products}
    
        if 'cart' not in st.session_state:
            st.session_state.cart = []

        selected_p = st.selectbox("Select Product", options=list(product_options.keys()))
        qty = st.number_input("Quantity", min_value=1, step=1)
    
        if st.button("➕ Add to Order"):
            p_data = product_options[selected_p]
            st.session_state.cart.append({
                'P_CODE': p_data['P_CODE'],
                'P_DESCRIPT': selected_p,
                'QUANTITY': qty,
                'PRICE': p_data['P_PRICE'],
                'TOTAL': qty * p_data['P_PRICE']
            })

    # Hiển thị giỏ hàng hiện tại
        if st.session_state.cart:
            df_cart = pd.DataFrame(st.session_state.cart)
            st.table(df_cart[['P_DESCRIPT', 'QUANTITY', 'PRICE', 'TOTAL']])
            total_bill = df_cart['TOTAL'].sum()
            st.metric("TOTAL AMOUNT", f"${total_bill:,.2f}")

            if st.button("✅ Confirm & Create Invoice"):
    # Kiểm tra nếu là khách mới thì phải nhập tên
                if is_new and not full_name:
                    st.error("Vui lòng nhập Customer Name cho khách hàng mới.")
                elif not st.session_state.cart:
                    st.error("Giỏ hàng đang trống!")
                else:
                    try:
                        customer_info = {
                            'FULL_NAME': full_name, 
                            'PHONE': phone, 
                            'CUS_CODE': cus_id if not is_new else None
                        }
            
            # --- KHÚC SỬA QUAN TRỌNG ---
            # Giả sử mã nhân viên đang trực máy là 1 (An kiểm tra bảng EMPLOYEE xem có ID này chưa nhé)
                        emp_code_session = 1 
            
            # Truyền thêm emp_code_session vào cuối hàm
                        inv_id = create_full_invoice(db, customer_info, st.session_state.cart, is_new, SECRET_KEY, emp_code_session)
            # ---------------------------

                        st.success(f"Hóa đơn #{inv_id} đã được tạo thành công!")
                        st.session_state.cart = []
                        st.rerun() 
            
                    except Exception as e:
                        st.error(f"Lỗi khi tạo hóa đơn: {e}")
    # --- ORDER HISTORY TAB  ---    
    elif choice == "📜 Order History":
        st.header("📜 Invoice Transaction History")
    
    # Lấy danh sách hóa đơn tổng quát
        all_invoices = get_all_orders(db) # Hàm này An đã viết ở các bước trước
        if all_invoices:
            df_inv = pd.DataFrame(all_invoices)
            st.dataframe(df_inv, use_container_width=True)
        
            st.divider()
        # Xem chi tiết
            selected_inv = st.number_input("Enter Invoice Number to inspect", min_value=1)
            if st.button("View Detailed Items"):
                inv_info, line_items = get_invoice_full_details(db, selected_inv)
                if inv_info:
                    st.subheader(f"Details for Invoice #{selected_inv}")
                    st.write(f"**Status:** {inv_info['INV_STATUS']} | **Total:** ${inv_info['INV_TOTAL']:,.2f}")
                    st.table(pd.DataFrame(line_items))
                else:
                    st.error("Invoice not found.")

    # --- ANALYTICS TAB (Manager Only) ---
    elif "Analytics" in choice and st.session_state.role == "Manager":
        st.header("Business Performance Reports")
        report_data = get_customer_report(db) # Utilizes VIEW
        if report_data:
            df = pd.DataFrame(report_data)
            m1, m2, m3 = st.columns(3)
            m1.metric("Total Customers", len(df))
            m2.metric("Total Revenue (PAID)", f"${df['TOTAL_SPENDING'].sum():,.2f}")
            m3.metric("Avg. Ticket Size", f"${df['AVERAGE_SPENDING_PER_INVOICE'].mean():,.2f}")
            
            st.divider()
            st.subheader("Spending Pattern by Customer")
            st.bar_chart(df.set_index('CUS_LNAME')['TOTAL_SPENDING'])
        else:
            st.info("No transaction data available for analytics yet.")

    # --- EMPLOYEES TAB (Manager Only) ---
    elif "Employees" in choice and st.session_state.role == "Manager":
        st.header("Employee Directory")
        employees = get_employee_list(db)
        if employees:
            st.dataframe(pd.DataFrame(employees), use_container_width=True)

    # --- SYSTEM LOGS TAB (Manager Only) ---
    elif "System Logs" in choice and st.session_state.role == "Manager":
        st.header("Administrative Audit Trail")
        if os.path.exists("system_activity.log"):
            with open("system_activity.log", "r", encoding="utf-8") as f:
                st.text_area("Live Activity Log", f.read(), height=400)

    # --- LOGOUT BUTTON ---
    if st.sidebar.button("Logout"):
        st.session_state.logged_in = False
        st.rerun()


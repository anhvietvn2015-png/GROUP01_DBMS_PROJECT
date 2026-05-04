import streamlit as st
import pandas as pd
import os
from db_manager import get_db
# Đảm bảo crud_logic.py đã có hàm get_customer_report và add_stock_units
from crud_logic import search_products, get_customer_report, add_stock_units
from logger import log_system_activity 

# 1. Cấu hình trang
st.set_page_config(page_title="NEU Sales Management System", layout="wide")
st.title("🛍️ Sales Management System - DSEB66A")

# 2. Thanh điều hướng (Chỉ khai báo menu 1 lần duy nhất)
menu = ["Product Management", "Business Reports", "System Logs"]
choice = st.sidebar.selectbox("Navigation", menu)

# 3. Nội dung các tab
if choice == "Product Management":
    st.header("📦 Product Inventory")
    
    with st.expander("Search Filters", expanded=True):
        col1, col2 = st.columns(2)
        with col1:
            search_name = st.text_input("Product Name")
        with col2:
            max_p = st.number_input("Max Price (Set 0 to show all)", min_value=0.0, value=0.0)

    if st.button("Search Products"):
        db = next(get_db())
        # Logic: Nếu max_p > 0 thì mới lọc theo giá
        actual_max_price = max_p if max_p > 0 else None
        results = search_products(db, name=search_name, max_price=actual_max_price)        
        
        if results:
            data = []
            for p in results:
                data.append({
                    "Product Code": p.P_CODE,
                    "Description": p.P_DESCRIPT,
                    "Category": p.P_CATEGORY,
                    "Stock (QOH)": p.P_QOH,
                    "Unit Price ($)": float(p.P_PRICE),
                    "Discount (%)": f"{int(p.P_DISCOUNT * 100)}%" # Hiển thị % cho đẹp
                })
        
            st.success(f"Found {len(results)} products.")
            st.dataframe(pd.DataFrame(data), use_container_width=True)
            # Log hành động tìm kiếm thành công
            log_system_activity("PRODUCT_SEARCH", f"Keyword: '{search_name}', Max Price: {max_p}")
        else:
            st.warning(f"No products found.")
            log_system_activity("SEARCH_EMPTY", f"No results for '{search_name}'")

    st.divider()
    st.subheader("🛠️ Admin Tools")
    col_a, col_b = st.columns(2)
    with col_a:
        p_code = st.number_input("Enter Product Code", min_value=1, step=1)
    with col_b:
        units = st.number_input("Units to Add", min_value=1, step=1)
        
    if st.button("Update Stock"):
        db = next(get_db())
        try:
            add_stock_units(db, p_code, units) # Gọi Procedure
            log_system_activity("UPDATE_STOCK", f"Added {units} units to P_CODE: {p_code}")
            st.success(f"Stock for Product {p_code} updated successfully!")
        except Exception as e:
            st.error(f"Error updating stock: {e}")

elif choice == "Business Reports":
    st.header("📊 Business Summary Reports")
    st.info("Reports generated from MySQL Views")
    db = next(get_db())
    
    report_data = get_customer_report(db) # Lấy dữ liệu từ VIEW
    if report_data:
        df_report = pd.DataFrame(report_data)
        st.subheader("Customer Purchase History (M3 Summary View)")
        st.dataframe(df_report, use_container_width=True)
        log_system_activity("VIEW_REPORT", "Accessed Customer Purchase Summary")

elif choice == "System Logs":
    st.header("📜 System Activity Logs")
    if os.path.exists("system_activity.log"):
        with open("system_activity.log", "r", encoding="utf-8") as f:
            logs = f.readlines()
            # Hiển thị log mới nhất lên đầu
            st.text_area("Audit Trail", "".join(reversed(logs)), height=450)
            
        if st.button("Clear Logs"):
            open("system_activity.log", "w").close()
            st.rerun()
    else:
        st.info("No logs recorded yet.")
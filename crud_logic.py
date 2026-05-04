from sqlalchemy import text
from sqlalchemy.orm import Session

# 1. Khai báo Secret Key 
SECRET_KEY = "group1_password"

# --- NHÓM HÀM CHO CẢ STAFF & MANAGER ---

def search_products(db: Session, name: str = None):
    """Sử dụng Procedure SEARCH_PRODUCT"""
    query = text("CALL SEARCH_PRODUCT(:kw)")
    result = db.execute(query, {"kw": name if name else ""})
    return result.all()

def add_stock_units(db: Session, p_code: int, units: int):
    """Cập nhật tồn kho qua Procedure ADD_STOCK"""
    try:
        query = text("CALL ADD_STOCK(:code, :qty)")
        db.execute(query, {"code": p_code, "qty": units})
        db.commit()
    except Exception as e:
        db.rollback()
        raise e

def create_order(db: Session, customer_id: int, employee_id: int):
    try:
        # Sử dụng đúng tên tham số p_cus_code và p_emp_code như trong SQL của bạn
        query = text("CALL CREATE_INVOICE(:p_cus_code, :p_emp_code)")
        result = db.execute(query, {
            "p_cus_code": customer_id, 
            "p_emp_code": employee_id
        })
        
        # 1. Lấy dữ liệu hóa đơn từ lệnh SELECT cuối cùng trong Procedure
        invoice_data = result.fetchone()
        
        # 2. DỌN DẸP TRIỆT ĐỂ: Duyệt qua tất cả các bộ kết quả thừa từ TRANSACTION/COMMIT
        while result.next_result():
            result.all() # Ép driver đọc sạch dữ liệu còn sót lại
            
        db.commit()
        return invoice_data
    except Exception as e:
        db.rollback()
        raise e
# --- NHÓM HÀM CẦN SECRET KEY (NHÂN VIÊN & KHÁCH HÀNG) ---

def get_customer_details(db: Session, customer_id: int):
    """Sửa hàm này để giải phóng cursor sau khi gọi procedure"""
    try:
        # Sử dụng secret key đã định nghĩa ở đầu file crud_logic.py
        query = text("CALL GET_CUSTOMER_DETAILS(:id, :key)")
        result = db.execute(query, {"id": customer_id, "key": SECRET_KEY})
        
        # Lấy dữ liệu
        data = result.fetchone()
        
        # QUAN TRỌNG: Đọc sạch các kết quả còn lại (nếu có) để tránh out of sync
        result.all() 
        
        return data
    except Exception as e:
        db.rollback()
        raise e
# --- NHÓM HÀM DÀNH RIÊNG CHO MANAGER ---

def get_employee_list(db: Session):
    # 'group1_password' là secret key bạn đã thống nhất với team
    query = text("CALL GET_EMPLOYEE_LIST(:key)")
    result = db.execute(query, {"key": "group1_password"})
    return result.all()

def search_customer_by_phone(db: Session, phone: str):
    try:
        # Sử dụng SECRET_KEY đã định nghĩa và đúng tên tham số p_cus_phone, secret_key
        query = text("CALL SEARCH_CUSTOMER(:p_cus_phone, :secret_key)")
        result = db.execute(query, {
            "p_cus_phone": phone,
            "secret_key": "group1_password" # Khớp với key Trang đã cài đặt
        })
        customer = result.fetchone()
        
        while result.next_result():
            pass
            
        return customer
    except Exception as e:
        raise e
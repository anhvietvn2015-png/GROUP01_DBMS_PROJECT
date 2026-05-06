from sqlalchemy import text
from sqlalchemy.orm import Session

# 1. Khai báo Secret Key 
SECRET_KEY = "@group1dbms"

# --- NHÓM HÀM CHO CẢ STAFF & MANAGER ---

def search_products(db: Session, name: str = None):
    """Sử dụng Raw Connection để trả về Dictionary, tránh lỗi tuple indices"""
    connection = db.connection().connection
    cursor = connection.cursor(dictionary=True)
    try:
        # Nếu name là "%" hoặc rỗng, SQL sẽ lấy toàn bộ sản phẩm
        cursor.callproc('SEARCH_PRODUCT', [name if name else "%"])
        results = list(cursor.stored_results())
        data = results[0].fetchall()
        return data
    finally:
        cursor.close()

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
    # We use a raw connection here to gain better control over the cursor
    connection = db.connection().connection
    cursor = connection.cursor(dictionary=True)
    
    try:
        # 1. Call the procedure using the raw cursor
        cursor.callproc('CREATE_INVOICE', [customer_id, employee_id])
        
        # 2. Extract the invoice data from the first result set
        invoice_data = None
        for result in cursor.stored_results():
            if invoice_data is None:
                invoice_data = result.fetchone()
            else:
                result.fetchall() # Exhaust any other result sets
        
        connection.commit()
        return invoice_data
    except Exception as e:
        connection.rollback()
        raise e
    finally:
        cursor.close()
    
# --- NHÓM HÀM CẦN SECRET KEY (NHÂN VIÊN & KHÁCH HÀNG) ---
def get_customer_details(db: Session, customer_id: int):
    """Lấy chi tiết 1 khách hàng để hiển thị JSON"""
    connection = db.connection().connection
    cursor = connection.cursor(dictionary=True)
    try:
        # Sử dụng đúng SECRET_KEY đã thống nhất
        cursor.callproc('GET_CUSTOMER_DETAILS', [customer_id, SECRET_KEY])
        results = list(cursor.stored_results())
        if results:
            return results[0].fetchone()
        return None
    finally:
        cursor.close()

def get_all_customers_full(db: Session, search_name: str = ""):
    """
    Hàm này thay thế logic cũ để lấy toàn bộ danh sách khách hàng.
    Hỗ trợ giải mã số điện thoại bằng SECRET_KEY mới (@group1dbms).
    """
    connection = db.connection().connection
    cursor = connection.cursor(dictionary=True)
    try:
        # SQL sử dụng LIKE để tìm kiếm theo tên và AES_DECRYPT để giải mã số điện thoại
        query = """
            SELECT 
                CUS_CODE, 
                CUS_LNAME AS Last_Name,
                COALESCE(CAST(AES_DECRYPT(CUS_PHONE_ENC, %s) AS CHAR), 'Decryption Failed') AS Phone_Number
            FROM CUSTOMER
            WHERE CUS_LNAME LIKE %s
            ORDER BY CUS_CODE DESC
        """
        # %search_name% giúp tìm kiếm khách hàng có tên chứa chuỗi ký tự bất kỳ
        cursor.execute(query, (SECRET_KEY, f"%{search_name}%"))
        return cursor.fetchall()
    finally:
        cursor.close()
# --- NHÓM HÀM DÀNH RIÊNG CHO MANAGER ---

def get_employee_list(db: Session):
    # 'group1_password' là secret key bạn đã thống nhất với team
    query = text("CALL GET_EMPLOYEE_LIST(:key)")
    result = db.execute(query, {"key": "@group1dbms"})
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
    
def add_customer(db: Session, name: str, phone: str):
    connection = db.connection().connection
    cursor = connection.cursor(dictionary=True)
    try:
        # Gọi ADD_CUSTOMER(name, phone, secret_key)
        cursor.callproc('ADD_CUSTOMER', [name, phone, SECRET_KEY])
        results = list(cursor.stored_results())
        result = results[0].fetchone()
        connection.commit()
        return result
    finally:
        cursor.close()

def add_line_item(db: Session, inv_num: int, p_code: int, qty: int):
    connection = db.connection().connection
    cursor = connection.cursor(dictionary=True)
    try:
        cursor.callproc('ADD_LINE', [inv_num, p_code, qty])
        connection.commit()
    finally:
        cursor.close()

def get_all_products(db: Session):
    """Lấy danh sách sản phẩm để hiển thị trong selectbox của Invoice"""
    connection = db.connection().connection
    cursor = connection.cursor(dictionary=True)
    try:
        query = "SELECT P_CODE, P_DESCRIPT, P_PRICE FROM PRODUCT"
        cursor.execute(query)
        return cursor.fetchall()
    finally:
        cursor.close()

def get_invoice_full_details(db: Session, inv_number: int):
    """Lấy thông tin tổng quát và chi tiết từng mặt hàng của một hóa đơn"""
    connection = db.connection().connection
    cursor = connection.cursor(dictionary=True)
    try:
        # 1. Lấy thông tin tổng quát
        cursor.execute("SELECT * FROM INVOICE WHERE INV_NUMBER = %s", (inv_number,))
        inv_info = cursor.fetchone()
        
        # 2. Lấy chi tiết các mặt hàng (Line items)
        line_query = """
            SELECT L.P_CODE, P.P_DESCRIPT, L.LINE_UNITS, L.LINE_PRICE, (L.LINE_UNITS * L.LINE_PRICE) AS LINE_TOTAL
            FROM LINE L
            JOIN PRODUCT P ON L.P_CODE = P.P_CODE
            WHERE L.INV_NUMBER = %s
        """
        cursor.execute(line_query, (inv_number,))
        line_items = cursor.fetchall()
        
        return inv_info, line_items
    finally:
        cursor.close()

def add_line_item(db: Session, inv_num: int, p_code: int, qty: int):
    # Lấy kết nối thô để kiểm soát tốt hơn
    connection = db.connection().connection
    cursor = connection.cursor()
    try:
        # Gọi Procedure thêm mặt hàng
        cursor.callproc('ADD_LINE', [inv_num, p_code, qty])
        
        # QUAN TRỌNG: Phải đọc hết mọi kết quả trả về từ MySQL 
        # (ngay cả khi Procedure không trả về gì) để tránh treo bộ nhớ
        for result in cursor.stored_results():
            result.fetchall()
            
        connection.commit()
    except Exception as e:
        connection.rollback()
        raise e
    finally:
        # Luôn luôn đóng cursor dù thành công hay thất bại
        cursor.close()

def get_all_orders(db: Session, customer_id: str = ""):
    connection = db.connection().connection
    cursor = connection.cursor(dictionary=True)
    try:
        if customer_id and customer_id.strip():
            # Filter by customer
            query = "SELECT * FROM INVOICE WHERE CUS_CODE = %s ORDER BY INV_DATE DESC"
            cursor.execute(query, (customer_id,))
        else:
            # Show all
            query = "SELECT * FROM INVOICE ORDER BY INV_DATE DESC"
            cursor.execute(query)
        return cursor.fetchall()
    finally:
        cursor.close() # Cực kỳ quan trọng để tránh lỗi Lock Timeout lần sau

def create_full_invoice(db: Session, customer_data, items_list, is_new_customer, secret_key, emp_code):
    connection = db.connection().connection
    cursor = connection.cursor(dictionary=True)
    try:
        cus_code = customer_data.get('CUS_CODE')
        
        # 1. Xử lý khách hàng (giữ nguyên logic cũ đã fix Hash và Name)
        if is_new_customer:
            insert_cus = """
                INSERT INTO CUSTOMER (CUS_LNAME, CUS_PHONE_ENC, CUS_PHONE_HASH) 
                VALUES (%s, AES_ENCRYPT(%s, %s), SHA2(%s, 256))
            """
            cursor.execute(insert_cus, (customer_data['FULL_NAME'], customer_data['PHONE'], secret_key, customer_data['PHONE']))
            cus_code = cursor.lastrowid
        
        # 2. Tạo hóa đơn - THÊM EMP_CODE VÀO ĐÂY
        # Trạng thái dùng 'PAID' để khớp với ENUM đã check ở bước trước
        insert_inv = """
            INSERT INTO INVOICE (CUS_CODE, INV_DATE, INV_TOTAL, INV_STATUS, EMP_CODE) 
            VALUES (%s, NOW(), 0, 'PAID', %s)
        """
        cursor.execute(insert_inv, (cus_code, emp_code))
        inv_number = cursor.lastrowid
        
        # 3. Thêm LINE giữ nguyên
        for item in items_list:
            insert_line = "INSERT INTO LINE (INV_NUMBER, P_CODE, LINE_UNITS, LINE_PRICE) VALUES (%s, %s, %s, %s)"
            cursor.execute(insert_line, (inv_number, item['P_CODE'], item['QUANTITY'], item['PRICE']))
            
        connection.commit()
        return inv_number
    except Exception as e:
        connection.rollback()
        raise e
    finally:
        cursor.close()
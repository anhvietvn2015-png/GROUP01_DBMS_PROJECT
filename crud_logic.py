from sqlalchemy import text
from sqlalchemy.orm import Session

# 1. Tìm kiếm sản phẩm (Sử dụng Procedure SEARCH_PRODUCT)
# Tối ưu: Thay vì dùng filter() của SQLAlchemy, ta gọi Procedure để Database xử lý tìm kiếm.
def search_products(db: Session, name: str = None, max_price: float = None):
    """
    Tìm kiếm sản phẩm dựa trên từ khóa Description.
    """
    # Gọi Procedure SEARCH_PRODUCT đã định nghĩa trong shop.sql
    query = text("CALL SEARCH_PRODUCT(:kw)")
    result = db.execute(query, {"kw": name if name else ""})
    return result.all()

# 2. Lấy báo cáo chi tiêu khách hàng (Sử dụng VIEW CUSTOMER_PURCHASE_SUMMARY)
# Tối ưu: Sử dụng View giúp giảm thiểu các lệnh JOIN phức tạp trong code Python.
def get_customer_report(db: Session):
    """
    Truy xuất báo cáo tổng hợp chi tiêu từ View quản trị.
    """
    query = text("SELECT * FROM CUSTOMER_PURCHASE_SUMMARY")
    result = db.execute(query)
    return result.all()

# 3. Cập nhật tồn kho (Sử dụng Procedure ADD_STOCK)
# Tối ưu: Đảm bảo dữ liệu được ghi log tự động nhờ Trigger sau khi Procedure thực thi.
def add_stock_units(db: Session, p_code: int, units: int):
    """
    Cập nhật số lượng sản phẩm và tự động kích hoạt Trigger ghi Log.
    """
    try:
        # Gọi Procedure ADD_STOCK để nhập thêm hàng
        query = text("CALL ADD_STOCK(:code, :qty)")
        db.execute(query, {"code": p_code, "qty": units})
        db.commit() # Xác nhận thay đổi vào Database
    except Exception as e:
        db.rollback() # Hoàn tác nếu có lỗi xảy ra
        raise e

# 4. Tạo đơn hàng mới (Sử dụng Procedure CREATE_INVOICE)
# Tối ưu: Tận dụng Trigger tự động tính toán tổng tiền (INV_TOTAL).
def create_order(db: Session, customer_id: int, employee_id: int):
    """
    Tạo một hóa đơn mới cho khách hàng.
    """
    try:
        query = text("CALL CREATE_INVOICE(:cus, :emp)")
        result = db.execute(query, {"cus": customer_id, "emp": employee_id})
        db.commit()
        return result.fetchone() # Trả về thông tin hóa đơn vừa tạo
    except Exception as e:
        db.rollback()
        raise e
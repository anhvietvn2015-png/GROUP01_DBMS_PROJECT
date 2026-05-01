from sqlalchemy import create_engine, text
from sqlalchemy.exc import OperationalError
import time

class DatabaseManager:
    def __init__(self, user, password, host, database):
        """Khởi tạo kết nối với Database MySQL[cite: 47]."""
        self.connection_string = f"mysql+mysqlconnector://{user}:{password}@{host}/{database}"
        # pool_recycle làm mới kết nối để tránh lỗi timeout
        self.engine = create_engine(self.connection_string, pool_recycle=3600, pool_pre_ping=True)

    def get_connection(self):
        """Hàm xử lý Reconnection, đảm bảo tính ổn định của hệ thống[cite: 44]."""
        attempts = 3
        while attempts > 0:
            try:
                return self.engine.connect()
            except OperationalError:
                print("Mất kết nối! Đang thử lại sau 2 giây...")
                time.sleep(2)
                attempts -= 1
        raise Exception("Không thể kết nối đến MySQL sau nhiều lần thử.")

    def execute_query(self, query, params=None):
        """Thực thi câu lệnh SQL đơn lẻ (INSERT, UPDATE, DELETE)."""
        with self.get_connection() as conn:
            result = conn.execute(text(query), params or {})
            conn.commit()
            return result

    def execute_many(self, query, list_of_params):
        """
        TỐI ƯU HÓA: Thực thi hàng loạt (Batch Processing).
        Giảm thiểu số lần truy vấn tới DB, giúp tăng hiệu năng[cite: 44].
        """
        with self.get_connection() as conn:
            conn.execute(text(query), list_of_params)
            conn.commit()

    def search_products(self, name=None, category=None, min_price=None, max_price=None):
        """Tìm kiếm sản phẩm với bộ lọc động[cite: 48]."""
        sql = "SELECT * FROM products WHERE 1=1"
        params = {}

        if name:
            sql += " AND product_name LIKE :name"
            params['name'] = f"%{name}%"
        if category:
            sql += " AND category = :category"
            params['category'] = category
        if min_price:
            sql += " AND price >= :min_price"
            params['min_price'] = min_price
        if max_price:
            sql += " AND price <= :max_price"
            params['max_price'] = max_price

        return self.execute_query(sql, params).fetchall()
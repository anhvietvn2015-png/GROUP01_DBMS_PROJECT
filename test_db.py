from db_manager import engine, get_db
from sqlalchemy import text

def test_connection():
    try:
        # 1. Thử kết nối trực tiếp qua engine
        with engine.connect() as connection:
            result = connection.execute(text("SELECT 1"))
            print("✅ Kết nối Database thành công!")
            
        # 2. Thử lấy session từ hàm get_db (để kiểm tra logic reconnection)
        db = get_db()
        if db:
            print("✅ Hàm get_db() hoạt động ổn định.")
            db.close()
            
    except Exception as e:
        print(f"❌ Kết nối thất bại. Lỗi: {e}")
        print("\nGợi ý cho An: Kiểm tra lại mật khẩu hoặc tên DB trong file .env nhé!")

if __name__ == "__main__":
    test_connection()
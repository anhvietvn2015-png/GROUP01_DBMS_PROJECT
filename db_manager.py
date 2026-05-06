import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
import pandas as pd

# Load cấu hình từ file .env cá nhân của bạn
load_dotenv()

# Xây dựng URL kết nối linh hoạt dựa trên file .env
DB_URL = f"mysql+mysqlconnector://{os.getenv('DB_USER')}:{os.getenv('DB_PASSWORD')}@{os.getenv('DB_HOST')}:{os.getenv('DB_PORT')}/{os.getenv('DB_NAME')}"

# Khởi tạo Engine với cơ chế tự kết nối lại (Handle Reconnection)
engine = create_engine(
    DB_URL,
    pool_pre_ping=True,  # Kiểm tra kết nối trước khi thực hiện lệnh
    pool_recycle=3600,   
    # Tự động làm mới kết nối sau 1 giờ
    connect_args={
        "buffered": True
    }
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# Hàm hỗ trợ lấy Session để thực hiện truy vấn
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def import_data(self):
    df = pd.read_csv('data/CUSTOMER.csv')
    
# Trong db_manager.py

def get_customers(self):
    # Dòng này thụt vào 1 Tab (hoặc 4 dấu cách)
    cursor = self.conn.cursor(dictionary=True) 
    query = "SELECT CUS_CODE, CUS_LNAME, CUS_PHONE_ENC AS CUS_PHONE FROM CUSTOMER"
    cursor.execute(query)
    
    rows = cursor.fetchall()
    processed_data = [] # Đảm bảo dòng này và dòng 'for' phía dưới thẳng hàng nhau

    for row in rows:
        # Nội dung bên trong 'for' phải thụt vào thêm 1 cấp nữa so với 'for'
        raw_phone = row['CUS_PHONE'] 
        # Giả sử bạn có logic giải mã ở đây (để đáp ứng yêu cầu bảo mật)
        processed_data.append(row)
        
    return processed_data

def decrypt_phone(self, encrypted_text):
    # Nếu bạn dùng thư viện cryptography, code sẽ dạng:
    # return cipher_suite.decrypt(encrypted_text).decode()
    
    # Nếu chỉ là dữ liệu giả lập như trong ảnh, bạn chỉ cần trả về chính nó 
    # hoặc xử lý cắt bỏ các ký tự thừa x1960...
    return encrypted_text
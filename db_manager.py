import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

# Load cấu hình từ file .env cá nhân của bạn
load_dotenv()

# Xây dựng URL kết nối linh hoạt dựa trên file .env
DB_URL = f"mysql+mysqlconnector://{os.getenv('DB_USER')}:{os.getenv('DB_PASSWORD')}@{os.getenv('DB_HOST')}:{os.getenv('DB_PORT')}/{os.getenv('DB_NAME')}"

# Khởi tạo Engine với cơ chế tự kết nối lại (Handle Reconnection)
engine = create_engine(
    DB_URL,
    pool_pre_ping=True,  # Kiểm tra kết nối trước khi thực hiện lệnh
    pool_recycle=3600    # Tự động làm mới kết nối sau 1 giờ
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
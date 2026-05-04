import logging
import os
from datetime import datetime

# Định nghĩa đường dẫn file log
log_file = 'system_activity.log'

# Đảm bảo file tồn tại để tránh lỗi quyền truy cập trên một số hệ thống
if not os.path.exists(log_file):
    with open(log_file, 'w', encoding='utf-8') as f:
        f.write(f"--- SYSTEM ACTIVITY LOG CREATED AT {datetime.now()} ---\n")

# Cấu hình logging
logging.basicConfig(
    filename=log_file,
    level=logging.INFO,
    # Thêm %(levelname)s để phân biệt INFO, WARNING, ERROR
    format='%(asctime)s | %(levelname)-8s | %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S',
    encoding='utf-8',
    force=True # Đảm bảo cấu hình được áp dụng lại nếu Streamlit reload
)

def log_system_activity(action, details, user="ADMIN"):
    """
    Logs actions for M3 task. 
    Trang có thể thêm tham số user để sau này mở rộng phần đăng nhập.
    """
    message = f"USER: {user} | ACTION: {action} | DETAILS: {details}"
    logging.info(message)
    # In ra console để Trang dễ theo dõi khi đang dev
    print(f"Log updated: {message}")
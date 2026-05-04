import logging
import os
from datetime import datetime

# Định nghĩa đường dẫn file log
log_file = 'system_activity.log'

# Đảm bảo file tồn tại để tránh lỗi quyền truy cập
if not os.path.exists(log_file):
    with open(log_file, 'w', encoding='utf-8') as f:
        f.write(f"--- SYSTEM ACTIVITY LOG CREATED AT {datetime.now()} ---\n")

# Cấu hình logging
logging.basicConfig(
    filename=log_file,
    level=logging.INFO,
    # Định dạng bao gồm: Thời gian | Mức độ | Nội dung chi tiết
    format='%(asctime)s | %(levelname)-8s | %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S',
    encoding='utf-8',
    force=True # Quan trọng: Đảm bảo cấu hình được áp dụng lại khi Streamlit reload
)

def log_system_activity(user, action, details):
    """
    Logs administrative actions for M3 task.
    Cập nhật tham số 'user' để ghi nhận đúng người thực hiện thao tác.
    """
    message = f"USER: {user} | ACTION: {action} | DETAILS: {details}"
    logging.info(message)
    
    # In ra console để bạn dễ theo dõi trong quá trình chạy thử (Development)
    print(f"Log updated: {message}")
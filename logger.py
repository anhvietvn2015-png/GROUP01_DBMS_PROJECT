import logging
import os

# Cấu hình log để ghi lại các thao tác quản trị [cite: 41]
if not os.path.exists('logs'):
    os.makedirs('logs')

logging.basicConfig(
    filename='logs/system_audit.log',
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    encoding='utf-8'
)

def log_action(user, action, target_id, details):
    """Ghi lại lịch sử thao tác hệ thống."""
    message = f"User: {user} | Action: {action} | ID: {target_id} | Info: {details}"
    logging.info(message)
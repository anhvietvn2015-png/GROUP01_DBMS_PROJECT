import logging

logging.basicConfig(
    filename='system_audit.log',
    level=logging.INFO,
    format='%(asctime)s | %(levelname)s | %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S',
    encoding='utf-8'
)

def log_event(emp_code, action):
    logging.info(f"EMP_{emp_code} executed: {action}")
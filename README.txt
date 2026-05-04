1. DANH SÁCH FILE VÀ CHỨC NĂNG
shopdb.sql: Tầng Dữ liệu (Database). Chứa toàn bộ cấu trúc bảng, Stored Procedures (CALL SEARCH_PRODUCT), Views và Triggers để tối ưu hóa hiệu suất truy vấn ngay tại Server.

db_manager.py: Quản lý kết nối. Sử dụng SQLAlchemy để tạo Session kết nối an toàn giữa Python và MySQL.

models.py: Định nghĩa thực thể (ORM). Chuyển đổi các bảng trong SQL thành các Class Python (Product, Order, Invoice) để dễ dàng thao tác dữ liệu.

crud_logic.py: Tầng Logic nghiệp vụ. Chứa các hàm điều hướng để gọi Stored Procedures và Views từ Database. Đây là phần cốt lõi của việc tối ưu Backend.

logger.py: Module Giám sát. Định nghĩa cơ chế ghi nhật ký hệ thống (Audit Trail) để lưu lại dấu vết thao tác của người dùng.

app.py: Giao diện người dùng (Frontend). Xây dựng bằng Streamlit, cho phép tìm kiếm sản phẩm, xem báo cáo doanh thu và quản lý kho hàng.

requirements.txt: Danh sách thư viện. Bao gồm Streamlit, Pandas, SQLAlchemy... cần thiết để cài đặt môi trường chạy ứng dụng.

system_activity.log: Nhật ký hoạt động. File vật lý lưu trữ mọi hành động Quản trị (Admin actions), đáp ứng yêu cầu giám sát của nhiệm vụ M3.

2. KIẾN TRÚC LIÊN KẾT (WORKFLOW)
Tương tác: Người dùng thực hiện thao tác trên giao diện app.py.

Xử lý: app.py yêu cầu dữ liệu thông qua các hàm trong crud_logic.py.

Truy vấn: crud_logic.py gọi các Stored Procedures trong MySQL. Việc này giúp giảm thiểu việc xử lý lặp lại tại Python và tăng tốc độ phản hồi.

Giám sát (M3): Mỗi hành động quan trọng (Search, Update Stock) sẽ được logger.py ghi lại vào file system_activity.log.

Hiển thị: Dữ liệu từ MySQL (bao gồm cả các báo cáo từ View) được trả về và hiển thị dưới dạng bảng Pandas trên màn hình.

3. HƯỚNG DẪN CHẠY CHƯƠNG TRÌNH
Database Setup: Chạy toàn bộ file shopdb.sql trong MySQL Workbench để khởi tạo bảng và logic Server.

Environment Setup: Cài đặt các thư viện bổ trợ bằng lệnh:
pip install -r requirements.txt

Run Application: Khởi động giao diện quản lý bằng lệnh:
streamlit run app.py

Monitoring: Truy cập tab "System Logs" trên giao diện để kiểm tra lịch sử hoạt động của hệ thống.

4. ĐIỂM NHẤN QUẢN TRỊ (MILESTONE M3)
Tối ưu Backend: Đã thay thế các truy vấn SQL thuần bằng Stored Procedures và Views để bảo mật và tăng hiệu suất.

Audit Trail: Hệ thống ghi log 2 lớp (Log file vật lý bằng Python và Log bảng nội bộ bằng Trigger trong MySQL).

Data Integrity: Sử dụng Trigger để tự động cập nhật tổng tiền hóa đơn và ngăn chặn các hành vi xóa dữ liệu quan trọng.
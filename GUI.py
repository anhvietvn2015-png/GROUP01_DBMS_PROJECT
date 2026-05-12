import customtkinter as ctk
from tkinter import ttk, messagebox
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg

# ==========================================
# CẤU HÌNH GIAO DIỆN HIỆN ĐẠI
# ==========================================
ctk.set_appearance_mode("System")  
ctk.set_default_color_theme("blue") 

class SalesAppM4:
    def __init__(self, root):
        self.root = root
        self.root.title("Sales Management System - GROUP 1")
        self.root.geometry("1200x820")

        # --- SIDEBAR (Menu điều hướng) ---
        self.sidebar = ctk.CTkFrame(self.root, width=260, corner_radius=0)
        self.sidebar.pack(side="left", fill="y")

        self.logo_label = ctk.CTkLabel(self.sidebar, text="DATCOM SALES", 
                                       font=ctk.CTkFont(size=22, weight="bold"), text_color="#3498db")
        self.logo_label.pack(pady=40)

        # Các nút Menu 
        btn_opts = {"fg_color": "transparent", "text_color": ("gray10", "gray90"), "hover_color": "#34495e", "anchor": "w"}
        
        ctk.CTkButton(self.sidebar, text="👤 Customer Management", command=self.show_customer_view, **btn_opts).pack(fill="x", padx=20, pady=10)
        ctk.CTkButton(self.sidebar, text="📦 Product Management", command=self.show_product_view, **btn_opts).pack(fill="x", padx=20, pady=10)
        ctk.CTkButton(self.sidebar, text="🛒 Order Processing", command=self.show_order_view, **btn_opts).pack(fill="x", padx=20, pady=10)
        ctk.CTkButton(self.sidebar, text="📊 Reports and Analytics", command=self.show_report_view, **btn_opts).pack(fill="x", padx=20, pady=10)

        # --- MAIN CONTENT AREA ---
        self.main_view = ctk.CTkFrame(self.root, corner_radius=20)
        self.main_view.pack(side="right", fill="both", expand=True, padx=20, pady=20)

        # Hiển thị Dashboard mặc định khi mở app
        self.show_report_view()

    def clear_view(self):
        """Hàm dọn dẹp view cũ trước khi chuyển sang tab mới"""
        for widget in self.main_view.winfo_children():
            widget.destroy()

    # ==========================================
    # 1. CUSTOMER MANAGEMENT
    # ==========================================
    def show_customer_view(self):
        self.clear_view()
        ctk.CTkLabel(self.main_view, text="QUẢN LÝ KHÁCH HÀNG", font=ctk.CTkFont(size=24, weight="bold")).pack(pady=20)

        form_frame = ctk.CTkFrame(self.main_view, fg_color="transparent")
        form_frame.pack(pady=10)

        ctk.CTkEntry(form_frame, placeholder_text="Mã KH", width=120).grid(row=0, column=0, padx=10)
        ctk.CTkEntry(form_frame, placeholder_text="Tên khách hàng", width=250).grid(row=0, column=1, padx=10)
        ctk.CTkEntry(form_frame, placeholder_text="Số điện thoại", width=180).grid(row=0, column=2, padx=10)
        ctk.CTkButton(form_frame, text="Đăng ký", width=100, command=lambda: messagebox.showinfo("Info", "Chờ M3 ghép logic!")).grid(row=0, column=3, padx=10)

        # CHỖ NÀY ĐỂ M3 NHÉT DỮ LIỆU SQL VÀO (thay thế data mock này)
        data = [("10011", "Dunne", "713-442-3422"), ("10012", "Smith", "615-297-1228"), ("10014", "Orlando", "305-442-1244")]
        self.render_table(["Mã KH", "Họ Tên", "Số điện thoại"], data)

    # ==========================================
    # 2. PRODUCT MANAGEMENT 
    # ==========================================
    def show_product_view(self):
        self.clear_view()
        ctk.CTkLabel(self.main_view, text="DANH SÁCH SẢN PHẨM", font=ctk.CTkFont(size=24, weight="bold")).pack(pady=20)

        columns = ["Mã SP", "Mô tả", "Đơn giá", "Tồn kho"]
        
        # CHỖ NÀY ĐỂ M3 NHÉT DỮ LIỆU SQL VÀO
        data = [("11QER/31", "Power painter,15 psi.", 109.99, 8),  # Tồn kho 8 < 10 -> Cảnh báo đỏ
                ("13-Q2/P2", "7.25-in. pwr. saw blade", 14.99, 32),
                ("1546-QQ2", "Hrdw. cloth, 1/2-in., 50-ft", 39.95, 5)]

        tree_frame = ctk.CTkFrame(self.main_view)
        tree_frame.pack(fill="both", expand=True, padx=20, pady=10)

        # Fix giao diện Treeview cho đẹp hơn
        style = ttk.Style()
        style.theme_use("default")
        style.configure("Treeview", rowheight=30, borderwidth=0)
        style.configure("Treeview.Heading", font=('Arial', 10, 'bold'))

        tree = ttk.Treeview(tree_frame, columns=columns, show="headings")
        for col in columns:
            tree.heading(col, text=col)
            tree.column(col, anchor="center")
        
        # Tag màu đỏ cho hàng sắp hết
        tree.tag_configure("low_stock", background="#ffcccc", foreground="red")

        for row in data:
            # Logic: Nếu index 3 (Tồn kho) < 10 thì gán tag màu đỏ
            tag = ("low_stock",) if row[3] < 10 else ()
            tree.insert("", "end", values=row, tags=tag)
        
        tree.pack(fill="both", expand=True)

    # ==========================================
    # 3. ORDER PROCESSING
    # ==========================================
    def show_order_view(self):
        self.clear_view()
        ctk.CTkLabel(self.main_view, text="TẠO ĐƠN HÀNG MỚI", font=ctk.CTkFont(size=24, weight="bold")).pack(pady=20)

        order_frame = ctk.CTkFrame(self.main_view, fg_color="transparent")
        order_frame.pack(pady=10)

        ctk.CTkLabel(order_frame, text="Mã SP:").grid(row=0, column=0, padx=5)
        self.p_code = ctk.CTkEntry(order_frame, width=120)
        self.p_code.grid(row=0, column=1, padx=5)

        ctk.CTkLabel(order_frame, text="Số lượng:").grid(row=0, column=2, padx=5)
        self.qty_entry = ctk.CTkEntry(order_frame, width=80)
        self.qty_entry.grid(row=0, column=3, padx=5)
        
        # Sự kiện tự động tính tiền khi gõ phím
        self.qty_entry.bind("<KeyRelease>", self.update_total)

        self.total_label = ctk.CTkLabel(order_frame, text="TỔNG: 0.00 VNĐ", 
                                        font=("Arial", 16, "bold"), text_color="#27ae60")
        self.total_label.grid(row=0, column=4, padx=20)

        ctk.CTkButton(order_frame, text="Thanh toán", fg_color="#27ae60", command=lambda: messagebox.showinfo("Info", "Chờ M3 ghép lệnh INSERT!")).grid(row=0, column=5, padx=5)

        # CHỖ NÀY ĐỂ M3 NHÉT DỮ LIỆU SQL VÀO
        data_orders = [("INV-001", "10011", "2026-05-08", "150.00", "PAID")]
        self.render_table(["Mã Đơn", "Mã KH", "Ngày", "Tổng Tiền", "Trạng Thái"], data_orders)

    def update_total(self, event):
        """UX M4: Tự động tính tiền mượt mà"""
        try:
            qty = int(self.qty_entry.get())
            price = 109.99 # Khi ghép nối, M3 sẽ truyền giá thực tế của sản phẩm vào đây
            total = qty * price
            self.total_label.configure(text=f"TỔNG: {total:,.2f} VNĐ")
        except ValueError:
            # Xử lý khi ô số lượng bị xóa trống
            self.total_label.configure(text="TỔNG: 0.00 VNĐ")

    # ==========================================
    # 4. REPORTS AND ANALYTICS
    # ==========================================
    def show_report_view(self):
        self.clear_view()
        ctk.CTkLabel(self.main_view, text="HỆ THỐNG BÁO CÁO & PHÂN TÍCH", font=ctk.CTkFont(size=24, weight="bold")).pack(pady=10)

        # Khung chứa Thẻ thống kê
        card_frame = ctk.CTkFrame(self.main_view, fg_color="transparent")
        card_frame.pack(fill="x", padx=20, pady=10)

        self.create_card(card_frame, "Doanh thu hôm nay", "1,500.00 VNĐ", "#2980b9").pack(side="left", expand=True, padx=10)
        self.create_card(card_frame, "Đơn hàng mới", "12 Đơn", "#27ae60").pack(side="left", expand=True, padx=10)
        self.create_card(card_frame, "Tồn kho thấp", "05 Sản phẩm", "#e74c3c").pack(side="left", expand=True, padx=10)

        # Khung chứa Biểu đồ
        chart_frame = ctk.CTkFrame(self.main_view)
        chart_frame.pack(fill="both", expand=True, padx=20, pady=10)

        fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(10, 4))
        fig.patch.set_facecolor('#ecf0f1')

        # Biểu đồ đường
        ax1.plot(["T2", "T3", "T4", "T5", "T6", "T7", "CN"], [200, 450, 300, 800, 600, 950, 1100], marker='o')
        ax1.set_title("Doanh thu theo thời gian")

        # Biểu đồ tròn
        ax2.pie([40, 30, 20, 10], labels=["Máy cưa", "Lưỡi cưa", "Dụng cụ", "Khác"], autopct='%1.1f%%')
        ax2.set_title("Cơ cấu doanh thu")

        canvas = FigureCanvasTkAgg(fig, master=chart_frame)
        canvas.draw()
        canvas.get_tk_widget().pack(fill="both", expand=True)

    # ==========================================
    # HÀM HỖ TRỢ DỰNG GIAO DIỆN
    # ==========================================
    def create_card(self, parent, title, val, color):
        f = ctk.CTkFrame(parent, fg_color=color, corner_radius=15, height=100)
        ctk.CTkLabel(f, text=title, text_color="white").pack(pady=5)
        ctk.CTkLabel(f, text=val, font=("Arial", 20, "bold"), text_color="white").pack(pady=5)
        return f

    def render_table(self, cols, rows):
        """Hàm vẽ bảng dùng chung cho các Tab"""
        f = ctk.CTkFrame(self.main_view)
        f.pack(fill="both", expand=True, padx=20, pady=10)
        
        style = ttk.Style()
        style.theme_use("default")
        style.configure("Treeview", rowheight=30, borderwidth=0)
        style.configure("Treeview.Heading", font=('Arial', 10, 'bold'))

        tree = ttk.Treeview(f, columns=cols, show="headings")
        for c in cols:
            tree.heading(c, text=c)
            tree.column(c, anchor="center")
        for r in rows:
            tree.insert("", "end", values=r)
        tree.pack(fill="both", expand=True)

if __name__ == "__main__":
    root = ctk.CTk()
    app = SalesAppM4(root)
    root.mainloop()
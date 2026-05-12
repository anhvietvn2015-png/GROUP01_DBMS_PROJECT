import customtkinter as ctk
from tkinter import ttk, messagebox
from db_manager import db_mgr
from logger import log_event
import utils

class SalesApp:
    def __init__(self, root, user_data):
        self.root = root
        self.user = user_data 
        self.root.title(f"DATCOM System - {self.user['EMP_JOB']}")
        self.root.geometry("1400x900")
        
        self.active_inv = None
        self.current_cus = None
        self.target_emp = None
        self.sp_list = []

        self.setup_sidebar()
        self.main_view = ctk.CTkFrame(self.root, corner_radius=0)
        self.main_view.pack(side="right", fill="both", expand=True)

        # 1. KIỂM TRA ĐỔI MẬT KHẨU LẦN ĐẦU
        if self.user.get('MUST_CHANGE_PASSWORD') == 1:
            self.root.after(500, self.show_force_password_view)
        else:
            self.show_customer_view()

    def setup_sidebar(self):
        self.sidebar = ctk.CTkFrame(self.root, width=240, corner_radius=0)
        self.sidebar.pack(side="left", fill="y")
        ctk.CTkLabel(self.sidebar, text="DATCOM MFE", font=("Arial", 22, "bold"), text_color="#3498db").pack(pady=40)
        
        menu = [
            ("👤 Khách hàng", self.show_customer_view),
            ("🛒 Lập hóa đơn", self.show_order_view),
            ("📦 Sản phẩm & Kho", self.show_product_view),
            ("📜 Lịch sử đơn", self.show_history_view)
        ]
        if self.user['EMP_JOB'].lower() == 'manager':
            menu.append(("👥 Nhân viên", self.show_employee_mgmt_view))
        menu.append(("📊 Báo cáo", self.show_report_view))

        for txt, cmd in menu:
            ctk.CTkButton(self.sidebar, text=txt, command=cmd, fg_color="transparent", anchor="w").pack(fill="x", padx=15, pady=5)
        ctk.CTkButton(self.sidebar, text="Thoát", fg_color="#e74c3c", command=self.root.destroy).pack(side="bottom", pady=20)

    def clear_view(self):
        for widget in self.main_view.winfo_children(): widget.destroy()

    # ==========================================
    # 1. ĐỔI MẬT KHẨU (EMPLOYEE_CHANGE_PASSWORD)
    # ==========================================
    def show_force_password_view(self):
        self.clear_view()
        overlay = ctk.CTkFrame(self.main_view, width=500, height=400, fg_color="#2b2b2b", corner_radius=15)
        overlay.place(relx=0.5, rely=0.5, anchor="center")
        ctk.CTkLabel(overlay, text="ĐỔI MẬT KHẨU LẦN ĐẦU", font=("Arial", 20, "bold"), text_color="#e74c3c").pack(pady=30)
        p1 = ctk.CTkEntry(overlay, placeholder_text="Mật khẩu mới", show="*", width=350); p1.pack(pady=10)
        p2 = ctk.CTkEntry(overlay, placeholder_text="Xác nhận", show="*", width=350); p2.pack(pady=10)
        def change():
            if p1.get() != p2.get(): messagebox.showerror("Lỗi", "Mật khẩu không khớp!"); return
            db_mgr.call_procedure("EMPLOYEE_CHANGE_PASSWORD", (self.user['EMP_CODE'], p1.get()))
            messagebox.showinfo("Xong", "Đã cập nhật mật khẩu!"); self.show_customer_view()
        ctk.CTkButton(overlay, text="CẬP NHẬT", command=change).pack(pady=20)

    # ==========================================
    # 2. KHÁCH HÀNG: HIỂN THỊ ĐỦ ID & SĐT
    # ==========================================
    def show_customer_view(self):
        self.clear_view()
        ctk.CTkLabel(self.main_view, text="QUẢN LÝ KHÁCH HÀNG", font=("Arial", 26, "bold")).pack(pady=30)
        f = ctk.CTkFrame(self.main_view, fg_color="transparent"); f.pack(fill="x", padx=50)
        ent = ctk.CTkEntry(f, placeholder_text="Nhập SĐT khách hàng...", width=400, height=45); ent.pack(side="left", padx=10)
        res_box = ctk.CTkTextbox(self.main_view, width=650, height=180, font=("Arial", 16)); res_box.pack(pady=20)

        def search():
            p_9 = utils.validate_phone(ent.get().strip())
            if not p_9: messagebox.showerror("Lỗi", "SĐT không hợp lệ"); return
            try:
                res = db_mgr.call_procedure("SEARCH_CUSTOMER", (p_9, db_mgr.secret_key))
                if res and res[0]:
                    self.current_cus = res[0][0]
                    res_box.delete("0.0", "end")
                    sdt_full = utils.format_phone_display(p_9)
                    # BỔ SUNG HIỂN THỊ ID VÀ SĐT THEO YÊU CẦU
                    info = f"ID KHÁCH HÀNG: {self.current_cus['CUS_CODE']}\n"
                    info += f"TÊN KHÁCH HÀNG: {self.current_cus['CUS_LNAME']}\n"
                    info += f"SỐ ĐIỆN THOẠI: {sdt_full}"
                    res_box.insert("0.0", info)
                else:
                    if messagebox.askyesno("Mới", "Đăng ký khách mới?"):
                        name = ctk.CTkInputDialog(text="Tên khách hàng:", title="Đăng ký").get_input()
                        if name:
                            db_mgr.call_procedure("ADD_CUSTOMER", (name[:10], p_9, db_mgr.secret_key))
                            search()
            except Exception as e: messagebox.showerror("Lỗi", str(e))
        ctk.CTkButton(f, text="TÌM KIẾM", command=search, width=120, height=45).pack(side="left")

    # ==========================================
    # 3. HÓA ĐƠN: TÍNH DISCOUNT & CHECK TỒN
    # ==========================================
    def show_order_view(self):
        self.clear_view()
        ctk.CTkLabel(self.main_view, text="LẬP HÓA ĐƠN", font=("Arial", 24, "bold")).pack(pady=20)
        f1 = ctk.CTkFrame(self.main_view, fg_color="transparent"); f1.pack(fill="x", padx=40)
        ctk.CTkLabel(f1, text="ID khách:").pack(side="left")
        c_ent = ctk.CTkEntry(f1, width=100); c_ent.pack(side="left", padx=10)
        if self.current_cus: c_ent.insert(0, str(self.current_cus['CUS_CODE']))

        f2 = ctk.CTkFrame(self.main_view); f2.pack(fill="x", padx=40, pady=15)
        se = ctk.CTkEntry(f2, placeholder_text="Tên SP...", width=200); se.pack(side="left", padx=5)
        cb = ctk.CTkComboBox(f2, values=["Chọn SP..."], width=350); cb.pack(side="left", padx=5)
        
        def find():
            r = db_mgr.call_procedure("SEARCH_PRODUCT", (f"%{se.get()}%",))
            if r and r[0]:
                self.sp_list = r[0]
                cb.configure(values=[f"{p['P_CODE']} - {p['P_DESCRIPT']} (Tồn: {p['P_QOH']})" for p in self.sp_list])
        ctk.CTkButton(f2, text="Tìm", command=find, width=60).pack(side="left")
        q_ent = ctk.CTkEntry(f2, placeholder_text="SL", width=60); q_ent.pack(side="left", padx=5)

    def add():
        try:
                # 1. Kiểm tra nhập ID khách hàng
            raw_cid = c_ent.get().strip()
            if not raw_cid:
                messagebox.showwarning("Lưu ý", "Bạn chưa nhập ID khách hàng!"); return
            cid = int(raw_cid)

                # 2. Kiểm tra chọn sản phẩm
            sel_text = cb.get()
            if sel_text == "Chọn SP..." or " - " not in sel_text:
                messagebox.showwarning("Lưu ý", "Vui lòng chọn sản phẩm từ danh sách!"); return
            pid = int(sel_text.split(" - ")[0])

                # 3. Kiểm tra nhập số lượng
            raw_qty = q_ent.get().strip()
            if not raw_qty:
                    messagebox.showwarning("Lưu ý", "Vui lòng nhập số lượng!"); return
            qty = int(raw_qty)

                # 4. Kiểm tra tồn kho (Tránh lỗi sp_list trống)
            if not self.sp_list:
                messagebox.showwarning("Lưu ý", "Hãy nhấn nút 'Tìm' để tải dữ liệu sản phẩm!"); return
                
            prod = next((p for p in self.sp_list if p['P_CODE'] == pid), None)
            if not prod:
                messagebox.showerror("Lỗi", "Không tìm thấy thông tin sản phẩm!"); return
                
            if qty > prod['P_QOH']:
                messagebox.showerror("Lỗi tồn kho", f"Sản phẩm còn số lượng: {prod['P_QOH']}"); return

                # 5. Gọi Procedure SQL
            if not self.active_inv:
                    # Chú ý: Đảm bảo procedure CREATE_INVOICE trả về INV_NUMBER
                res = db_mgr.call_procedure("CREATE_INVOICE", (cid, self.user['EMP_CODE']))
                if res and res[0]:
                    self.active_inv = res[0][0]['INV_NUMBER']
                else:
                    raise Exception("SQL không tạo được hóa đơn. Kiểm tra ID khách!")
                
            db_mgr.call_procedure("ADD_LINE", (self.active_inv, pid, qty))
            self.refresh_bill()

        except ValueError:
            messagebox.showerror("Lỗi định dạng", "ID khách và Số lượng phải là số nguyên!");
        except Exception as e:
                # Hiện lỗi thật từ SQL để bạn dễ sửa
            messagebox.showerror("Lỗi hệ thống", f"Chi tiết: {str(e)}")

    def refresh_bill(self):
        for w in self.bill_f.winfo_children(): w.destroy()
        if not self.active_inv: return
        res = db_mgr.call_procedure("SHOW_INVOICE_DETAILS", (self.active_inv,))
        tree = ttk.Treeview(self.bill_f, columns=("STT", "SP", "Giá", "SL", "Giảm", "Tổng"), show="headings")
        for c in tree["columns"]: tree.heading(c, text=c); tree.column(c, anchor="center")
        for l in res[1]:
            ds = float(l.get('P_DISCOUNT', 0))
            subtotal = (l['LINE_PRICE'] * l['LINE_UNITS']) * (1 - ds/100)
            tree.insert("", "end", values=(l['LINE_NUMBER'], l['P_DESCRIPT'], utils.format_currency(l['LINE_PRICE']), l['LINE_UNITS'], f"{ds}%", utils.format_currency(subtotal)))
        tree.pack(fill="both", expand=True)
        
        pay_f = ctk.CTkFrame(self.bill_f, fg_color="transparent"); pay_f.pack(pady=10)
        self.pm = ctk.CTkSegmentedButton(pay_f, values=["Tiền mặt", "Chuyển khoản"]); self.pm.set("Tiền mặt"); self.pm.pack(side="left", padx=20)
        ctk.CTkButton(pay_f, text=f"THANH TOÁN: {utils.format_currency(res[0][0]['INV_TOTAL'])}", height=45, command=self.pay).pack(side="left")

    def pay(self):
        db_mgr.call_procedure("PAY_INVOICE_CASH", (self.active_inv, self.user['EMP_CODE']))
        messagebox.showinfo("Xong", f"Đã thanh toán bằng {self.pm.get()}!"); self.active_inv = None; self.show_order_view()

    # ==========================================
    # 4. NHÂN VIÊN: HIỂN THỊ ĐỦ ID & SĐT
    # ==========================================
    def show_employee_mgmt_view(self):
        self.clear_view()
        ctk.CTkLabel(self.main_view, text="QUẢN TRỊ NHÂN VIÊN", font=("Arial", 22, "bold")).pack(pady=20)
        f = ctk.CTkFrame(self.main_view, fg_color="transparent"); f.pack(fill="x", padx=40)
        ent = ctk.CTkEntry(f, placeholder_text="SĐT nhân viên...", width=350); ent.pack(side="left", padx=10)
        res_box = ctk.CTkTextbox(self.main_view, width=650, height=200, font=("Arial", 16)); res_box.pack(pady=20)

        def find():
            p_9 = utils.validate_phone(ent.get().strip())
            if not p_9: return
            try:
                r = db_mgr.call_procedure("SEARCH_EMPLOYEE", (p_9, db_mgr.secret_key))
                if r and r[0]:
                    self.target_emp = r[0][0]
                    res_box.delete("0.0", "end")
                    sdt_full = utils.format_phone_display(p_9)
                    # BỔ SUNG HIỂN THỊ ID VÀ SĐT THEO YÊU CẦU
                    info = f"MÃ NHÂN VIÊN (ID): {self.target_emp['EMP_CODE']}\n"
                    info += f"HỌ TÊN: {self.target_emp['EMP_FNAME']} {self.target_emp['EMP_LNAME']}\n"
                    info += f"CHỨC VỤ: {self.target_emp['EMP_JOB']}\n"
                    info += f"SỐ ĐIỆN THOẠI: {sdt_full}"
                    res_box.insert("0.0", info)
                else: messagebox.showerror("Lỗi", "Không tìm thấy!")
            except Exception as e: messagebox.showerror("Lỗi", str(e))
        ctk.CTkButton(f, text="TÌM NHÂN VIÊN", command=find).pack(side="left")

        bf = ctk.CTkFrame(self.main_view, fg_color="transparent"); bf.pack(pady=10)
        def add():
            n = ctk.CTkInputDialog(text="Tên NV:", title="Add").get_input()
            j = ctk.CTkInputDialog(text="Chức vụ:", title="Add").get_input()
            p = ctk.CTkInputDialog(text="SĐT:", title="Add").get_input()
            if n and j and p: db_mgr.call_procedure("ADD_EMPLOYEE", (n, "Staff", j, utils.validate_phone(p), db_mgr.secret_key)); messagebox.showinfo("Xong", "Đã thêm!")
        ctk.CTkButton(bf, text="+ Thêm Staff", command=add, fg_color="#27ae60").pack(side="left", padx=5)
        ctk.CTkButton(bf, text="Lên Manager", command=lambda: [db_mgr.call_procedure("UPDATE_JOB", (self.target_emp['EMP_CODE'], "Manager")), find()] if self.target_emp else None).pack(side="left", padx=5)
        ctk.CTkButton(bf, text="Nghỉ việc", command=lambda: [db_mgr.call_procedure("DEACTIVATE_EMPLOYEE", (self.target_emp['EMP_CODE'],)), find()] if self.target_emp else None, fg_color="#e74c3c").pack(side="left", padx=5)

    # ==========================================
    # 5. KHO HÀNG & LỊCH SỬ (GIỮ NGUYÊN)
    # ==========================================
    def show_product_view(self):
        self.clear_view()
        ctk.CTkLabel(self.main_view, text="QUẢN LÝ KHO", font=("Arial", 22, "bold")).pack(pady=20)
        f = ctk.CTkFrame(self.main_view, fg_color="transparent"); f.pack(fill="x", padx=40)
        e = ctk.CTkEntry(f, placeholder_text="Tên SP...", width=300); e.pack(side="left", padx=10)
        tree = ttk.Treeview(self.main_view, columns=("ID", "Tên", "Kho", "Giá", "Giảm %"), show="headings", height=15)
        for c in tree["columns"]: tree.heading(c, text=c); tree.column(c, anchor="center")
        def load():
            for i in tree.get_children(): tree.delete(i)
            r = db_mgr.call_procedure("SEARCH_PRODUCT", (f"%{e.get()}%",))
            for p in r[0]: tree.insert("", "end", values=(p['P_CODE'], p['P_DESCRIPT'], p['P_QOH'], utils.format_currency(p['P_PRICE']), f"{p['P_DISCOUNT']}%"))
        ctk.CTkButton(f, text="Tìm", command=load).pack(side="left")
        tree.pack(fill="both", expand=True, padx=40, pady=10)
        def act(p_name):
            sel = tree.selection()
            if not sel: return
            pid = tree.item(sel[0])['values'][0]
            val = ctk.CTkInputDialog(text="Giá trị mới:", title="Update").get_input()
            if val: db_mgr.call_procedure(p_name, (int(pid), float(val))); load()
        bf = ctk.CTkFrame(self.main_view, fg_color="transparent"); bf.pack(pady=10)
        ctk.CTkButton(bf, text="Nhập kho", command=lambda: act("ADD_STOCK")).pack(side="left", padx=5)
        ctk.CTkButton(bf, text="Đổi giá", command=lambda: act("UPDATE_PRICE")).pack(side="left", padx=5)
        ctk.CTkButton(bf, text="Giảm giá %", command=lambda: act("UPDATE_DISCOUNT")).pack(side="left", padx=5)
        load()

    def show_history_view(self):
        self.clear_view()
        ctk.CTkLabel(self.main_view, text="LỊCH SỬ GIAO DỊCH", font=("Arial", 22, "bold")).pack(pady=20)
        cid = self.current_cus['CUS_CODE'] if self.current_cus else 1
        res = db_mgr.call_procedure("SEARCH_INVOICE", (cid,))
        tree = ttk.Treeview(self.main_view, columns=("STT", "ID HD", "Ngày", "Status", "Tổng", "Cus", "Emp"), show="headings")
        for c in tree["columns"]: tree.heading(c, text=c); tree.column(c, anchor="center")
        for idx, i in enumerate(res[0], 1):
            tree.insert("", "end", values=(idx, i['INV_NUMBER'], i['INV_DATE'], i['INV_STATUS'], utils.format_currency(i['INV_TOTAL']), i['CUS_CODE'], i['EMP_CODE']))
        tree.pack(fill="both", expand=True, padx=40)
        def detail():
            sel = tree.selection()
            if not sel: return
            hid = tree.item(sel[0])['values'][1]
            d = db_mgr.call_procedure("SHOW_INVOICE_DETAILS", (hid,))
            c = d[0][0]
            msg = f"KHÁCH: {c['CUS_LNAME']} (ID: {c['CUS_CODE']})\nSĐT: {utils.format_phone_display(c['CUS_PHONE'])}\n" + "-"*30 + "\n"
            for p in d[1]: msg += f"- {p['P_DESCRIPT']}: {utils.format_currency(p['LINE_PRICE'])} x {p['LINE_UNITS']} (-{p.get('P_DISCOUNT',0)}%)\n"
            messagebox.showinfo(f"Chi tiết #{hid}", msg)
        ctk.CTkButton(self.main_view, text="XEM CHI TIẾT", command=detail, fg_color="#34495e").pack(pady=10)

    def show_report_view(self):
        self.clear_view()
        ctk.CTkLabel(self.main_view, text="BÁO CÁO", font=("Arial", 22, "bold")).pack(pady=20)
        try:
            import matplotlib.pyplot as plt
            from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
            db_mgr.connect()
            cur = db_mgr.connection.cursor(dictionary=True)
            cur.execute("SELECT CONCAT(SALE_MONTH, '/', SALE_YEAR) as m, TOTAL_REVENUE as r FROM monthly_revenue_summary LIMIT 6")
            data = cur.fetchall(); cur.close()
            fig, ax = plt.subplots(figsize=(6, 4))
            ax.bar([d['m'] for d in data], [float(d['r']) for d in data], color="#3498db")
            FigureCanvasTkAgg(fig, master=self.main_view).get_tk_widget().pack(fill="both", expand=True)
        except: ctk.CTkLabel(self.main_view, text="Chưa có dữ liệu báo cáo.").pack(pady=50)

# ==========================================
# KHỞI CHẠY HỆ THỐNG
# ==========================================
if __name__ == "__main__":
    ctk.set_appearance_mode("dark")
    win = ctk.CTk(); win.title("Login"); win.geometry("400x500")
    u = ctk.CTkEntry(win, placeholder_text="Username", width=280); u.pack(pady=(100, 10))
    p = ctk.CTkEntry(win, placeholder_text="Password", show="*", width=280); p.pack(pady=10)
    def login():
        try:
            res = db_mgr.call_procedure("LOGIN_EMPLOYEE", (u.get(), p.get()))
            if res and res[0]:
                user_data = res[0][0]; win.withdraw()
                main_root = ctk.CTk(); SalesApp(main_root, user_data); main_root.mainloop()
                win.destroy()
            else: messagebox.showerror("Lỗi", "Sai tài khoản!")
        except Exception as e: messagebox.showerror("Lỗi", str(e))
    ctk.CTkButton(win, text="ĐĂNG NHẬP", command=login, width=280, height=45).pack(pady=40)
    win.mainloop()
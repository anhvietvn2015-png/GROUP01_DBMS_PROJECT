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
        
        # Menu cơ bản cho tất cả nhân viên
        menu = [
            ("👤 Khách hàng", self.show_customer_view),
            ("🛒 Lập hóa đơn", self.show_order_view),
            ("📦 Sản phẩm & Kho", self.show_product_view),
            ("📜 Lịch sử đơn", self.show_history_view)
        ]

        # PHÂN QUYỀN: Chỉ Manager mới được thêm nút Nhân viên và Báo cáo
        # Kiểm tra chức vụ từ dữ liệu login (user_data)
        if self.user['EMP_JOB'].lower() == 'manager':
            menu.append(("👥 Nhân viên", self.show_employee_mgmt_view))
            menu.append(("📊 Báo cáo", self.show_report_view)) # Đã đưa vào trong IF

        # Khởi tạo các nút bấm từ danh sách menu đã phân quyền
        for txt, cmd in menu:
            ctk.CTkButton(
                self.sidebar, 
                text=txt, 
                command=cmd, 
                fg_color="transparent", 
                anchor="w",
                hover_color="#2c3e50"
            ).pack(fill="x", padx=15, pady=5)

        # Nút thoát luôn nằm dưới cùng
        ctk.CTkButton(
            self.sidebar, 
            text="Thoát", 
            fg_color="#e74c3c", 
            hover_color="#c0392b",
            command=self.root.destroy
        ).pack(side="bottom", pady=20)

    def clear_view(self):
        # Hàm này dùng để dọn dẹp màn hình cũ trước khi chuyển sang chức năng mới
        if hasattr(self, 'main_view'):
            for widget in self.main_view.winfo_children(): 
                widget.destroy()

    # ==========================================
    # 1. ĐỔI MẬT KHẨU (EMPLOYEE_CHANGE_PASSWORD)
    # ==========================================
    def show_force_password_view(self):
        self.clear_view()
        # Tạo khung hiển thị chính giữa màn hình
        overlay = ctk.CTkFrame(self.main_view, width=500, height=400, fg_color="#2b2b2b", corner_radius=15)
        overlay.place(relx=0.5, rely=0.5, anchor="center")
        
        ctk.CTkLabel(overlay, text="ĐỔI MẬT KHẨU LẦN ĐẦU", font=("Arial", 20, "bold"), text_color="#e74c3c").pack(pady=30)
        
        p1 = ctk.CTkEntry(overlay, placeholder_text="Mật khẩu mới", show="*", width=350)
        p1.pack(pady=10)
        
        p2 = ctk.CTkEntry(overlay, placeholder_text="Xác nhận mật khẩu", show="*", width=350)
        p2.pack(pady=10)

        def change():
            new_pass = p1.get()
            confirm_pass = p2.get()

            # Kiểm tra khớp mật khẩu
            if new_pass != confirm_pass:
                messagebox.showerror("Lỗi", "Mật khẩu xác nhận không khớp!")
                return
            
            # Kiểm tra độ dài mật khẩu (Ví dụ tối thiểu 4 ký tự)
            if len(new_pass) < 4:
                messagebox.showwarning("Lưu ý", "Mật khẩu quá ngắn, vui lòng nhập ít nhất 4 ký tự!")
                return

            try:
                # GỌI PROCEDURE ĐỔI MẬT KHẨU
                db_mgr.call_procedure("EMPLOYEE_CHANGE_PASSWORD", (self.user['EMP_CODE'], new_pass))
                
                # QUAN TRỌNG: Xác nhận lưu thay đổi vào Database
                db_mgr.connection.commit()
                
                messagebox.showinfo("Thành công", "Mật khẩu đã được cập nhật!")
                
                # Cập nhật lại trạng thái trong bộ nhớ tạm để không hiện lại bảng này nữa
                self.user['MUST_CHANGE_PASSWORD'] = 0 
                
                # Chuyển về màn hình chính
                self.show_customer_view()
                
            except Exception as e:
                # Nếu lỗi thì quay lại trạng thái cũ
                db_mgr.connection.rollback()
                messagebox.showerror("Lỗi hệ thống", f"Không thể đổi mật khẩu: {str(e)}")

        ctk.CTkButton(overlay, text="XÁC NHẬN CẬP NHẬT", command=change, fg_color="#27ae60").pack(pady=20)

    # ==========================================
    # 2. KHÁCH HÀNG: HIỂN THỊ ĐỦ ID & SĐT
    # ==========================================
    def show_customer_view(self):
        self.clear_view()
        ctk.CTkLabel(self.main_view, text="QUẢN LÝ KHÁCH HÀNG", font=("Arial", 26, "bold")).pack(pady=30)
        
        f_search = ctk.CTkFrame(self.main_view, fg_color="transparent")
        f_search.pack(fill="x", padx=50)
        
        ent = ctk.CTkEntry(f_search, placeholder_text="Nhập SĐT khách hàng...", width=400, height=45)
        ent.pack(side="left", padx=10)
        
        res_box = ctk.CTkTextbox(self.main_view, width=650, height=180, font=("Arial", 16))
        res_box.pack(pady=20)

        # --- Hàm tìm kiếm ---
        def search():
            p_val = ent.get().strip()
            p_9 = utils.validate_phone(p_val)
            if not p_9: 
                messagebox.showerror("Lỗi", "Số điện thoại không hợp lệ!"); return
            try:
                res = db_mgr.call_procedure("SEARCH_CUSTOMER", (p_9, db_mgr.secret_key))
                if res and res[0]:
                    self.current_cus = res[0][0]
                    res_box.delete("0.0", "end")
                    info = f"ID KHÁCH HÀNG: {self.current_cus['CUS_CODE']}\n"
                    info += f"TÊN KHÁCH HÀNG: {self.current_cus['CUS_LNAME']}\n"
                    info += f"SỐ ĐIỆN THOẠI: {utils.format_phone_display(p_9)}"
                    res_box.insert("0.0", info)
            except Exception as e:
                if "NO CUSTOMER FOUND" in str(e):
                    if messagebox.askyesno("Mới", "Số này chưa có. Đăng ký khách mới?"):
                        name = ctk.CTkInputDialog(text="Nhập tên khách:", title="Đăng ký").get_input()
                        if name:
                            db_mgr.call_procedure("ADD_CUSTOMER", (name[:10], p_9, db_mgr.secret_key))
                            db_mgr.connection.commit()
                            search()
                else:
                    messagebox.showerror("Lỗi", str(e))

        ctk.CTkButton(f_search, text="TÌM KIẾM / THÊM", command=search, width=120, height=45).pack(side="left")

        def update():
            if not self.current_cus:
                messagebox.showwarning("Chú ý", "Hãy tìm khách hàng trước!"); return

            edit_win = ctk.CTkToplevel(self.root)
            edit_win.title("Cập nhật thông tin")
            edit_win.geometry("400x350")
            edit_win.attributes("-topmost", True)

            ctk.CTkLabel(edit_win, text="Cập nhật thông tin khách", font=("Arial", 16, "bold")).pack(pady=15)
            
            new_name_ent = ctk.CTkEntry(edit_win, width=300)
            new_name_ent.insert(0, self.current_cus['CUS_LNAME'])
            new_name_ent.pack(pady=10)

            new_phone_ent = ctk.CTkEntry(edit_win, placeholder_text="SĐT mới (bỏ trống nếu không đổi)...", width=300)
            new_phone_ent.pack(pady=10)

            def save_changes():
                name = new_name_ent.get().strip()
                phone_raw = new_phone_ent.get().strip()
                
                try:
                    # 1. Nếu tên thay đổi, gọi procedure cập nhật tên
                    if name != self.current_cus['CUS_LNAME']:
                        # Gọi đúng tên: UPDATE_CUSTOMER_NAME
                        db_mgr.call_procedure("UPDATE_CUSTOMER_NAME", (self.current_cus['CUS_CODE'], name))
                    
                    # 2. Nếu có nhập số điện thoại mới, gọi procedure cập nhật SĐT
                    if phone_raw:
                        p_new = utils.validate_phone(phone_raw) # Đảm bảo số hợp lệ
                        if p_new:
                            # Gọi đúng tên: UPDATE_CUSTOMER_PHONE
                            db_mgr.call_procedure("UPDATE_CUSTOMER_PHONE", (self.current_cus['CUS_CODE'], p_new, db_mgr.secret_key))
                    
                    # QUAN TRỌNG: Phải có commit để lưu thay đổi
                    db_mgr.connection.commit()
                    
                    messagebox.showinfo("Thành công", "Đã cập nhật thông tin khách hàng!")
                    edit_win.destroy()
                    search() # Load lại thông tin mới lên màn hình chính
                    
                except Exception as e:
                    db_mgr.connection.rollback() # Hủy lệnh nếu có lỗi
                    messagebox.showerror("Lỗi SQL", f"Không thể cập nhật: {str(e)}")

            ctk.CTkButton(edit_win, text="LƯU THAY ĐỔI", command=save_changes, fg_color="#27ae60").pack(pady=20)

        # NÚT BẤM CHÍNH (Đảm bảo thụt lề bằng với f_search.pack)
        ctk.CTkButton(self.main_view, text="CẬP NHẬT THÔNG TIN", fg_color="#34495e", command=update, width=200).pack(pady=10)

    # ==========================================
    # 3. HÓA ĐƠN: TÍNH DISCOUNT & CHECK TỒN
    # ==========================================
    def show_order_view(self):
        self.clear_view()
        ctk.CTkLabel(self.main_view, text="LẬP HÓA ĐƠN", font=("Arial", 24, "bold")).pack(pady=20)
        
        # --- Phần 1: Thông tin khách hàng ---
        f1 = ctk.CTkFrame(self.main_view, fg_color="transparent")
        f1.pack(fill="x", padx=40)
        ctk.CTkLabel(f1, text="Mã khách (ID):").pack(side="left")
        
        self.c_ent = ctk.CTkEntry(f1, width=100)
        self.c_ent.pack(side="left", padx=10)
        if self.current_cus:
            self.c_ent.insert(0, str(self.current_cus['CUS_CODE']))

        # --- Phần 2: Tìm và Chọn sản phẩm ---
        f2 = ctk.CTkFrame(self.main_view)
        f2.pack(fill="x", padx=40, pady=15)
        
        self.se = ctk.CTkEntry(f2, placeholder_text="Nhập tên SP cần tìm...", width=200)
        self.se.pack(side="left", padx=5)
        
        self.cb = ctk.CTkComboBox(f2, values=["Chọn sản phẩm..."], width=350)
        self.cb.pack(side="left", padx=5)
        
        def find():
            r = db_mgr.call_procedure("SEARCH_PRODUCT", (f"%{self.se.get().strip()}%",))
            if r and r[0]:
                self.sp_list = r[0]
                self.cb.configure(values=[f"{p['P_CODE']} - {p['P_DESCRIPT']} (Tồn: {p['P_QOH']})" for p in self.sp_list])
            else:
                messagebox.showinfo("Thông báo", " không tìm thấy sản phẩm này!")
        
        ctk.CTkButton(f2, text="Tìm", command=find, width=60).pack(side="left")
        
        self.q_ent = ctk.CTkEntry(f2, placeholder_text="SL", width=60)
        self.q_ent.pack(side="left", padx=5)

        # --- ĐỊNH NGHĨA CÁC HÀM BỔ TRỢ (CÙNG CẤP THỤT DÒNG VỚI FIND) ---

        def refresh_bill():
            for w in self.bill_f.winfo_children(): w.destroy()
            if not self.active_inv: return
            try:
                res = db_mgr.call_procedure("SHOW_INVOICE_DETAILS",(self.active_inv,))
                if not res or len(res) < 2:
                    return
                inv_info = res[0][0]
                lines = res[1]
                tree = ttk.Treeview(self.bill_f,columns=("LINE", "PCODE", "SP", "Giá", "SL", "Giảm", "Tổng"),show="headings",height=8)

                tree.heading("LINE", text="STT")
                tree.heading("PCODE", text="P_CODE")
                tree.heading("SP", text="Sản phẩm")
                tree.heading("Giá", text="Giá")
                tree.heading("SL", text="SL")
                tree.heading("Giảm", text="Giảm")
                tree.heading("Tổng", text="Tổng")

                tree.column("PCODE", width=0, stretch=False)

                for c in tree["columns"]:
                    tree.column(c, anchor="center")

                tree.pack(fill="both", expand=True)

                for l in lines:

                    ds_val = 0

                    if hasattr(self, 'sp_list'):
                        for p in self.sp_list:
                            if p['P_CODE'] == l['P_CODE']:
                                ds_val = float(p.get('P_DISCOUNT', 0))
                                break

                    ds_pct = ds_val * 100 if 0 < ds_val < 1 else ds_val

                    price = float(l['LINE_PRICE'])
                    units = float(l['LINE_UNITS'])

                    subtotal = (
                        price * units
                    ) * (1.0 - (ds_pct / 100.0))

                    tree.insert(
                        "",
                        "end",
                        values=(
                            l['LINE_NUMBER'],
                            l['P_CODE'],
                            l['P_DESCRIPT'],
                            utils.format_currency(price),
                            int(units),
                            f"{ds_pct}%",
                            utils.format_currency(subtotal)
                        )
                    )           

        # ================= UPDATE =================

                def do_update():

                    sel = tree.selection()

                    if not sel:
                        messagebox.showwarning("Chú ý","Vui lòng chọn sản phẩm!")
                        return

                    item_data = tree.item(sel[0])['values']

                    p_code = int(item_data[1])

                    new_qty = ctk.CTkInputDialog(
                        text="Nhập SL mới:",
                        title="Sửa SL"
                    ).get_input()

                    if new_qty and new_qty.isdigit():

                        try:
                            db_mgr.call_procedure("UPDATE_UNITS",(int(self.active_inv),p_code,int(new_qty)))
                            db_mgr.connection.commit()
                            refresh_bill()
                        except Exception as e:
                            db_mgr.connection.rollback()
                            messagebox.showerror("Lỗi UPDATE",str(e))

        # ================= DELETE =================

                def do_delete():
                    sel = tree.selection()
                    if not sel:
                        messagebox.showwarning("Chú ý", "Vui lòng chọn sản phẩm!")
                        return
                    item_data = tree.item(sel[0])['values']
                    p_code = int(item_data[1])
                    if messagebox.askyesno("Xác nhận","Bạn muốn xóa sản phẩm này?"):
                        try:
                            db_mgr.call_procedure("DELETE_LINE",(int(self.active_inv),p_code))
                            db_mgr.connection.commit()
                            refresh_bill()
                        except Exception as e:
                            db_mgr.connection.rollback()
                            messagebox.showerror("Lỗi DELETE",str(e))

        # ================= CANCEL =================

                def do_cancel():
                    if not self.active_inv: return
                    if messagebox.askyesno("Xác nhận",f"Hủy hóa đơn #{self.active_inv}?"):
                        try:
                            db_mgr.call_procedure("CANCEL_INVOICE",(self.active_inv,))
                            db_mgr.connection.commit()
                            messagebox.showinfo("Thành công",f"Hóa đơn {self.active_inv} đã CANCELLED")
                            self.active_inv = None
                            self.show_order_view()
                        except Exception as e:
                            db_mgr.connection.rollback()
                            messagebox.showerror("Lỗi CANCEL",str(e))
                pay_f = ctk.CTkFrame(self.bill_f,fg_color="transparent")
                pay_f.pack(pady=10, fill="x")

                self.pm = ctk.CTkSegmentedButton(pay_f,values=["Tiền mặt", "Chuyển khoản"])
                self.pm.set("Tiền mặt")

                self.pm.pack(side="left", padx=20)

                ctk.CTkButton(pay_f,text="Sửa SL",width=80,command=do_update).pack(side="left", padx=5)
                ctk.CTkButton(pay_f,text="Xóa món",fg_color="#e67e22",width=80,command=do_delete).pack(side="left", padx=5)
                ctk.CTkButton(pay_f,text="Hủy hóa đơn",command=do_cancel).pack(side="left", padx=5)

                total_money = float(inv_info.get('INV_TOTAL', 0))
                ctk.CTkButton(pay_f,text=f"THANH TOÁN: {utils.format_currency(total_money)}",fg_color="#27ae60",command=self.pay).pack(side="right", padx=10) 
            except Exception as e:
                messagebox.showerror("Lỗi hiển thị hóa đơn",str(e))

        def add():
            try:
                cid = int(self.c_ent.get())
                qty = int(self.q_ent.get())
                sel_text = self.cb.get()
                if "Chọn sản phẩm" in sel_text: return
                pid = int(sel_text.split(" - ")[0])

                if not self.active_inv:
                    res = db_mgr.call_procedure("CREATE_INVOICE", (cid, self.user['EMP_CODE']))
                    self.active_inv = res[0][0]['INV_NUMBER']
                    db_mgr.connection.commit()

                try:
                    db_mgr.call_procedure("ADD_LINE", (self.active_inv, pid, qty))
                    db_mgr.connection.commit()
                except Exception as e:
                    # Tự động xử lý nếu sản phẩm đã tồn tại
                    if "ALREADY ADDED" in str(e) or "1644" in str(e):
                        temp_res = db_mgr.call_procedure("SHOW_INVOICE_DETAILS", (self.active_inv,))
                        line_to_update = next((r['LINE_NUMBER'] for r in temp_res[1] if r['P_CODE'] == pid), None)
                        if line_to_update:
                            db_mgr.call_procedure("UPDATE_UNITS", (self.active_inv, line_to_update, qty))
                            db_mgr.connection.commit()
                    else: raise e

                refresh_bill() 
                self.q_ent.delete(0, 'end')
            except Exception as e:
                db_mgr.connection.rollback()
                messagebox.showerror("Lỗi SQL", f"Không thể thêm hàng: {str(e)}")

        # --- TIẾP TỤC PHẦN GIAO DIỆN CHÍNH ---
        ctk.CTkButton(f2, text="THÊM VÀO ĐƠN", command=add, fg_color="#27ae60", width=120).pack(side="left", padx=10)
        if hasattr(self, 'bill_f') and self.bill_f.winfo_exists():
            self.bill_f.destroy()   

        self.bill_f = ctk.CTkFrame(self.main_view)
        self.bill_f.pack(fill="both", expand=True, padx=40, pady=10)
        
        refresh_bill()

        
    
    def pay(self):
        if not self.active_inv: return
        
        # Lấy phương thức thanh toán từ self.pm (SegmentedButton)
        method = self.pm.get() 
        
        if messagebox.askyesno("Xác nhận", f"Thanh toán đơn #{self.active_inv} bằng {method}?"):
            try:
                if method == "Tiền mặt":
                    # Giả sử Procedure PAY_INVOICE_CASH chỉ cần 2 tham số
                    db_mgr.call_procedure("PAY_INVOICE_CASH", (self.active_inv, self.user['EMP_CODE']))
                else:
                    # THANH TOÁN NGÂN HÀNG: Cần 3 tham số
                    # Bước 1: Hỏi mã tham chiếu (Transaction Reference)
                    pay_ref = ctk.CTkInputDialog(text="Nhập mã tham chiếu/mã giao dịch:", title="Thanh toán Bank").get_input()
                    
                    if not pay_ref: # Nếu khách hủy ngang không nhập mã
                        messagebox.showwarning("Chú ý", "Vui lòng nhập mã tham chiếu để hoàn tất thanh toán Bank!")
                        return

                    # Bước 2: Gọi đúng thứ tự: (p_inv_number, p_pay_ref, p_emp_code)
                    db_mgr.call_procedure("PAY_INVOICE_BANK", (self.active_inv, pay_ref, self.user['EMP_CODE']))
                
                # CHỐT DỮ LIỆU
                db_mgr.connection.commit()
                messagebox.showinfo("Thành công", f"Hóa đơn {self.active_inv} đã chuyển sang trạng thái PAID!")
                
                # Reset để làm đơn mới
                self.active_inv = None
                self.show_order_view() # Load lại giao diện trắng
                
            except Exception as e:
                db_mgr.connection.rollback()
                messagebox.showerror("Lỗi thanh toán", f"Chi tiết: {str(e)}")
    # ==========================================
    # 4. NHÂN VIÊN: HIỂN THỊ ĐỦ ID & SĐT
    # ==========================================
    def show_employee_mgmt_view(self):
        self.clear_view()
        self.target_emp = None
        ctk.CTkLabel(self.main_view, text="QUẢN TRỊ NHÂN VIÊN", font=("Arial", 22, "bold")).pack(pady=20)
            # ================= SEARCH =================
        f = ctk.CTkFrame(self.main_view, fg_color="transparent"); f.pack(fill="x", padx=40)
        ent = ctk.CTkEntry(f, placeholder_text="SĐT nhân viên...", width=350); ent.pack(side="left", padx=10)
        res_box = ctk.CTkTextbox(self.main_view, width=650, height=200, font=("Arial", 16)); res_box.pack(pady=20)

        # 1. HÀM TÌM NHÂN VIÊN (SEARCH_EMPLOYEE)
        def find():
            p_val = ent.get().strip()
            p_9 = utils.validate_phone(p_val)
            if not p_9: 
                messagebox.showerror("Lỗi", "SĐT không hợp lệ"); return
            try:
                # Call Procedure Tìm kiếm
                r = db_mgr.call_procedure("SEARCH_EMPLOYEE", (p_9, db_mgr.secret_key))
                if r and r[0]:
                    self.target_emp = r[0][0]
                    res_box.delete("0.0", "end")
                    sdt_full = utils.format_phone_display(p_9)
                    status = (
                        "ĐANG LÀM"
                        if self.target_emp['EMP_ACTIVE'] == 1
                        else "NGHỈ VIỆC"
                    )
                    info = ""
                    info += f"MÃ NHÂN VIÊN (ID): {self.target_emp['EMP_CODE']}\n"
                    info += f"HỌ TÊN: {self.target_emp['EMP_FNAME']} {self.target_emp['EMP_LNAME']}\n"
                    info += f"CHỨC VỤ: {self.target_emp['EMP_JOB']}\n"
                    info += f"TRẠNG THÁI: {status}\n"
                    info += f"SỐ ĐIỆN THOẠI: {sdt_full}"
                    res_box.insert("0.0", info)
                else:
                    self.target_emp = None
                    messagebox.showerror("Lỗi", "Không tìm thấy nhân viên này!")
            except Exception as e:
                messagebox.showerror("Lỗi SQL", str(e))

        ctk.CTkButton(f, text="TÌM NHÂN VIÊN", command=find).pack(side="left")

        bf = ctk.CTkFrame(self.main_view, fg_color="transparent"); bf.pack(pady=10)

        # 2. HÀM THÊM NHÂN VIÊN (ADD_STAFF)
        def add_staff():
            fname = ctk.CTkInputDialog(text="Nhập Tên (Fname):", title="Thêm Staff").get_input()
            lname = ctk.CTkInputDialog(text="Nhập Họ (Lname):", title="Thêm Staff").get_input()
            phone = ctk.CTkInputDialog(text="Nhập SĐT:", title="Thêm Staff").get_input()
            password = ctk.CTkInputDialog(text="Nhập mật khẩu:",title="Thêm Staff").get_input()

            if not all([fname, lname, phone, password]):
                return
            p_v = utils.validate_phone(phone)
                
            if not p_v:
                messagebox.showerror("Lỗi","SĐT không hợp lệ")
                return
            try:
                    # FIX: Gọi đúng ADD_STAFF thay vì ADD_EMPLOYEE
                db_mgr.call_procedure("ADD_STAFF", (fname, lname, p_v, password, db_mgr.secret_key))
                db_mgr.connection.commit() # Quan trọng
                messagebox.showinfo("Xong", "Đã thêm nhân viên mới vào hệ thống!")
            except Exception as e:
                db_mgr.connection.rollback()
                messagebox.showerror("Lỗi", str(e))

        ctk.CTkButton(bf, text="+ Thêm Staff", command=add_staff, fg_color="#27ae60").pack(side="left", padx=5)
            # ================= ADD MANAGER =================
        def add_manager():
            fname = ctk.CTkInputDialog(text="Nhập Tên (Fname):",title="Thêm Manager").get_input()
            lname = ctk.CTkInputDialog(text="Nhập Họ (Lname):",title="Thêm Manager").get_input()
            phone = ctk.CTkInputDialog(text="Nhập SĐT:",title="Thêm Manager").get_input()
            password = ctk.CTkInputDialog(text="Nhập mật khẩu:",title="Thêm Manager").get_input()

            if not all([fname, lname, phone, password]):
                return

            p_v = utils.validate_phone(phone)

            if not p_v:
                messagebox.showerror("Lỗi","SĐT không hợp lệ")
                return

            try:
                db_mgr.call_procedure("ADD_MANAGER",(lname,fname,p_v,password,db_mgr.secret_key))
                db_mgr.connection.commit()
                messagebox.showinfo("Thành công","Đã thêm MANAGER mới!")
            except Exception as e:
                db_mgr.connection.rollback()
                messagebox.showerror("Lỗi ADD_MANAGER",str(e))
        ctk.CTkButton(bf,text="+ Thêm MANAGER",command=add_manager,fg_color="#2980b9").pack(side="left", padx=5)
        # 3. HÀM CẬP NHẬT CHỨC VỤ (UPDATE_JOB)
        def update_job():
            if not self.target_emp:
                messagebox.showwarning("Chú ý", "Hãy tìm nhân viên trước!"); return
            new_job = ctk.CTkInputDialog(text="Nhập STAFF hoặc MANAGER:",title="Đổi chức vụ").get_input()
            if not new_job: return

            new_job = new_job.upper().strip()
            
            if new_job not in ["STAFF", "MANAGER"]:
                messagebox.showerror("Lỗi","Chỉ được nhập STAFF hoặc MANAGER")
                return
            
            try:
                db_mgr.call_procedure("UPDATE_JOB", (self.target_emp['EMP_CODE'], new_job))
                db_mgr.connection.commit()
                messagebox.showinfo("Thành công", "Đã cập nhật chức vụ!"); find()
            except Exception as e:
                db_mgr.connection.rollback()
                messagebox.showerror("Lỗi", str(e))

        ctk.CTkButton(bf, text="Đổi chức vụ", command=update_job).pack(side="left", padx=5)

        # 4. HÀM VÔ HIỆU HÓA TÀI KHOẢN (DEACTIVATE_EMPLOYEE)
        def deactivate():
            if not self.target_emp: return
            if messagebox.askyesno("Xác nhận", "Bạn có chắc muốn cho nhân viên này nghỉ việc?"):
                try:
                    db_mgr.call_procedure("DEACTIVATE_EMPLOYEE", (self.target_emp['EMP_CODE'],))
                    db_mgr.connection.commit()
                    messagebox.showinfo("Xong", "Đã cập nhật trạng thái nghỉ việc!"); find()
                except Exception as e:
                    db_mgr.connection.rollback()
                    messagebox.showerror("Lỗi", str(e))

        ctk.CTkButton(bf, text="Nghỉ việc", command=deactivate, fg_color="#e74c3c").pack(side="left", padx=5)

    # ==========================================
    # 5. KHO HÀNG & LỊCH SỬ (GIỮ NGUYÊN)
    # ==========================================
    # ==========================================
    # 1. QUẢN LÝ KHO (FIX LỖI COMMIT DỮ LIỆU)
    # ==========================================
    def show_product_view(self):
        self.clear_view()
        ctk.CTkLabel(self.main_view, text="QUẢN LÝ KHO", font=("Arial", 22, "bold")).pack(pady=20)
        
        f = ctk.CTkFrame(self.main_view, fg_color="transparent")
        f.pack(fill="x", padx=40)
        
        e = ctk.CTkEntry(f, placeholder_text="Tên sản phẩm...", width=300)
        e.pack(side="left", padx=10)
        
        tree = ttk.Treeview(self.main_view, columns=("ID", "Tên", "Kho", "Giá", "Giảm %"), show="headings", height=15)
        for c in tree["columns"]: 
            tree.heading(c, text=c)
            tree.column(c, anchor="center")
        
        def load():
            for i in tree.get_children(): tree.delete(i)
            # CALL PROCEDURE: SEARCH_PRODUCT
            r = db_mgr.call_procedure("SEARCH_PRODUCT", (f"%{e.get()}%",))
            if r and r[0]:
                for p in r[0]:
                    tree.insert("", "end", values=(
                        p['P_CODE'], 
                        p['P_DESCRIPT'], 
                        p['P_QOH'], 
                        utils.format_currency(p['P_PRICE']), 
                        f"{p['P_DISCOUNT']}"
                    ))
        
        ctk.CTkButton(f, text="Tìm kiếm", command=load).pack(side="left")
        tree.pack(fill="both", expand=True, padx=40, pady=10)
        
        def act(p_name):
            sel = tree.selection()
            if not sel: 
                messagebox.showwarning("Lưu ý", "Vui lòng chọn một sản phẩm từ bảng!"); return
            
            pid = tree.item(sel[0])['values'][0]
            val = ctk.CTkInputDialog(text="Nhập giá trị mới (Số lượng/Giá/Giảm giá):", title="Cập nhật kho").get_input()
            
            if val:
                try:
                    # CALL PROCEDURE: ADD_STOCK, UPDATE_PRICE, hoặc UPDATE_DISCOUNT
                    db_mgr.call_procedure(p_name, (int(pid), float(val)))
                    
                    # QUAN TRỌNG: Lưu thay đổi vào Database
                    db_mgr.connection.commit()
                    
                    messagebox.showinfo("Thành công", "Đã cập nhật dữ liệu sản phẩm!")
                    load() # Tải lại bảng
                except Exception as ex:
                    db_mgr.connection.rollback()
                    messagebox.showerror("Lỗi", f"Không thể cập nhật: {str(ex)}")

        bf = ctk.CTkFrame(self.main_view, fg_color="transparent")
        bf.pack(pady=10)
        
        # Các nút gọi Procedure thay đổi dữ liệu
        ctk.CTkButton(bf, text="Nhập kho", command=lambda: act("ADD_STOCK")).pack(side="left", padx=5)
        ctk.CTkButton(bf, text="Đổi giá", command=lambda: act("UPDATE_PRICE")).pack(side="left", padx=5)
        ctk.CTkButton(bf, text="Giảm giá %", command=lambda: act("UPDATE_DISCOUNT")).pack(side="left", padx=5)
        
        load()

    # ==========================================
    # 2. LỊCH SỬ GIAO DỊCH (FIX LỖI HIỂN THỊ CHI TIẾT)
    # ==========================================
    def show_history_view(self):
        self.clear_view()
        ctk.CTkLabel(self.main_view, text="LỊCH SỬ GIAO DỊCH", font=("Arial", 22, "bold")).pack(pady=20)
        if not self.current_cus:
            messagebox.showwarning(
            "Thông báo",
            "Vui lòng tìm khách hàng trước!"
        )
            return
        
        cid = self.current_cus['CUS_CODE']
        
        try:
            res = db_mgr.call_procedure("SEARCH_INVOICE", (cid,))
        except Exception as e:
            messagebox.showerror("Lỗi SEARCH_INVOICE",str(e))
            return
        # Tạo bảng hiển thị danh sách hóa đơn
        tree = ttk.Treeview(self.main_view, columns=("STT", "Mã HD", "Ngày", "Trạng thái", "Tổng tiền"), show="headings", height=12)
        for c in tree["columns"]: 
            tree.heading(c, text=c)
            tree.column(c, anchor="center")
            
        if res and res[0]:
            for idx, i in enumerate(res[0], 1):
                tree.insert("", "end", values=(
                    idx, 
                    i['INV_NUMBER'], 
                    i['INV_DATE'], 
                    i['INV_STATUS'], 
                    utils.format_currency(float(i['INV_TOTAL']))
                ))
        
        tree.pack(fill="both", expand=True, padx=40)

        # HÀM XEM CHI TIẾT (Nằm bên trong show_history_view để không lỗi self)
        def detail(self):
            sel = tree.selection() # Giả sử treeview của bạn tên là history_tree
            if not sel: 
                messagebox.showwarning("Chú ý", "Vui lòng chọn một hóa đơn!")
                return
            
        # Lấy mã hóa đơn từ dòng được chọn
            hid = tree.item(sel[0])['values'][1] 
        
            try:
        # GỌI PROCEDURE GỐC
                res = db_mgr.call_procedure("SHOW_INVOICE_DETAILS", (hid,))
        
                if res and len(res) >= 2:
                    info = res[0][0]
                    lines = res[1]
            
            # Xây dựng nội dung hiển thị (Dùng .get() để tránh lỗi Unknown Column)
                    msg = f"HÓA ĐƠN: #{hid}\n"
                    msg += f"Khách hàng: {info.get('CUS_LNAME', 'N/A')}\n"
                    msg += f"Ngày lập: {info.get('INV_DATE', 'N/A')}\n"
                    msg += "-"*40 + "\n"
            
                    for p in lines:
                # Vì SQL gốc không trả về Discount, ta chỉ hiện Giá và SL
                        price = float(p.get('LINE_PRICE', 0))
                        qty = int(p.get('LINE_UNITS', 0))
                        msg += f"• {p.get('P_DESCRIPT', 'SP')}: {qty} x {utils.format_currency(price)}\n"
            
                    total = float(info.get('INV_TOTAL', 0))
                    msg += "-"*40 + f"\nTỔNG CỘNG: {utils.format_currency(total)}"
                    messagebox.showinfo(f"Chi tiết đơn #{hid}", msg)
            except Exception as e:
                messagebox.showerror("Lỗi chi tiết hóa đơn",str(e))
        # Nút bấm xem chi tiết
        ctk.CTkButton(self.main_view,text="XEM CHI TIẾT ĐƠN HÀNG",command=detail,fg_color="#34495e",height=40).pack(pady=15)
    # ==========================================
    # 3. BÁO CÁO (FIX LỖI KẾT NỐI)
    # ==========================================
    def show_report_view(self):
        self.clear_view()
        ctk.CTkLabel(self.main_view, text="BÁO CÁO DOANH THU", font=("Arial", 22, "bold")).pack(pady=20)
        try:
            import matplotlib.pyplot as plt
            plt.close('all')
            plt.style.use("dark_background")
            from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
            # =========================
        # CHECK DB CONNECTION
        # =========================
            # Đảm bảo kết nối database đang mở
            if not db_mgr.connection or not db_mgr.connection.is_connected():
                db_mgr.connect()
                
            cur = db_mgr.connection.cursor(dictionary=True)
            # Truy vấn View monthly_revenue_summary
            cur.execute("""
                SELECT *
                FROM monthly_revenue_summary 
                ORDER BY SALE_YEAR, SALE_MONTH
            """)            
            revenue_data = cur.fetchall()

            cur.execute("""
                SELECT *
                FROM yearly_product_sales_summary
                ORDER BY TOTAL_REVENUE DESC
                LIMIT 5
            """)

            product_data = cur.fetchall()

            cur.execute("""
                SELECT *
                FROM customer_purchase_summary
                ORDER BY TOTAL_SPENDING DESC
                LIMIT 5
            """)
            customer_data = cur.fetchall()

            cur.execute("""
                SELECT *
                FROM customer_invoice_summary
                ORDER BY INV_DATE DESC
                LIMIT 10
            """)

            invoice_data = cur.fetchall()

            cur.close()
            # =========================
        # KPI FRAME
        # =========================
            kpi_frame = ctk.CTkFrame(self.main_view)
            kpi_frame.pack(fill="x",padx=20,pady=10)

            total_rev = sum(float(x['TOTAL_REVENUE']) for x in revenue_data)

            total_inv = sum(int(x['TOTAL_PAID_INVOICES']) for x in revenue_data)

            avg_rev = 0

            if total_inv > 0:
                avg_rev = total_rev / total_inv

            kpis = [
                ("Tổng doanh thu", f"{total_rev:,.0f} VNĐ"),
                ("Số hóa đơn", str(total_inv)),
                ("TB / hóa đơn", f"{avg_rev:,.0f} VNĐ"),
                ("Khách hàng VIP", str(len(customer_data)))
            ]   

            for title, value in kpis:

                card = ctk.CTkFrame(kpi_frame)
                card.pack(side="left",expand=True,fill="both",padx=10,pady=10)
                ctk.CTkLabel(card,text=title,font=("Arial", 15)).pack(pady=10)
                ctk.CTkLabel(card,text=value,font=("Arial", 22, "bold"),text_color="#2ecc71").pack(pady=10)
            # =========================
            # CHART FRAME
            # =========================
            chart_frame = ctk.CTkFrame(self.main_view)
            chart_frame.pack(fill="both",expand=True,padx=20,pady=10)
        # =====================================
        # CHART 1 - MONTHLY REVENUE
        # =====================================
            fig1, ax1 = plt.subplots(figsize=(5, 4))
            labels = [
                f"{x['SALE_MONTH']}/{x['SALE_YEAR']}"
                for x in revenue_data
            ]

            values = [
                float(x['TOTAL_REVENUE'])
                for x in revenue_data
            ]

            ax1.plot(labels, values, marker='o')

            ax1.set_title("Doanh thu theo tháng")

            ax1.tick_params(axis='x', rotation=45)

            canvas1 = FigureCanvasTkAgg(
                fig1,
                master=chart_frame
            )

            canvas1.draw()

            canvas1.get_tk_widget().pack(
                side="left",
                fill="both",
                expand=True,
                padx=10,
                pady=10
            )
            # =====================================
            # CHART 2 - TOP PRODUCTS
            # =====================================

            fig2, ax2 = plt.subplots(figsize=(5, 4))

            p_names = [
                x['P_DESCRIPT']
                for x in product_data
            ]

            p_values = [
                float(x['TOTAL_REVENUE'])
                for x in product_data
            ]

            ax2.bar(p_names, p_values)

            ax2.set_title("Top sản phẩm")

            ax2.tick_params(axis='x', rotation=25)

            canvas2 = FigureCanvasTkAgg(
                fig2,
                master=chart_frame
            )

            canvas2.draw()

            canvas2.get_tk_widget().pack(
                side="left",
                fill="both",
                expand=True,
                padx=10,
                pady=10
            )

            # =========================
            # TABLE FRAME
            # =========================

            table_frame = ctk.CTkFrame(self.main_view)

            table_frame.pack(
                fill="both",
                expand=True,
                padx=20,
                pady=10
            )

            # =====================================
            # CUSTOMER TABLE
            # =====================================
            left = ctk.CTkFrame(table_frame)

            left.pack(
                side="left",
                fill="both",
                expand=True,
                padx=10
            )

            ctk.CTkLabel(
                left,
                text="TOP KHÁCH HÀNG",
                font=("Arial", 18, "bold")
            ).pack(pady=10)

            customer_tree = ttk.Treeview(
                left,
                columns=("ID", "NAME", "SPENDING"),
                show="headings",
                height=8
            )

            customer_tree.heading("ID", text="ID")
            customer_tree.heading("NAME", text="Khách hàng")
            customer_tree.heading("SPENDING", text="Chi tiêu")

            customer_tree.pack(
                fill="both",
                expand=True
            )

            for c in customer_data:

                customer_tree.insert(
                    "",
                    "end",
                    values=(
                        c['CUS_CODE'],
                        c['CUS_LNAME'],
                        f"{float(c['TOTAL_SPENDING']):,.0f} VNĐ"
                    )
                )

            # =====================================
            # INVOICE TABLE
            # =====================================

            right = ctk.CTkFrame(table_frame)

            right.pack(
                side="left",
                fill="both",
                expand=True,
                padx=10
            )

            ctk.CTkLabel(
                right,
                text="HÓA ĐƠN GẦN ĐÂY",
                font=("Arial", 18, "bold")
            ).pack(pady=10)

            invoice_tree = ttk.Treeview(
                right,
                columns=("INV", "CUS", "STATUS", "TOTAL"),
                show="headings",
                height=8
            )

            invoice_tree.heading("INV", text="Invoice")
            invoice_tree.heading("CUS", text="Khách")
            invoice_tree.heading("STATUS", text="Trạng thái")
            invoice_tree.heading("TOTAL", text="Tổng tiền")

            invoice_tree.pack(
                fill="both",
                expand=True
            )

            for i in invoice_data:

                invoice_tree.insert(
                    "",
                    "end",
                    values=(
                        i['INV_NUMBER'],
                        i['CUS_LNAME'],
                        i['INV_STATUS'],
                        f"{float(i['INV_TOTAL']):,.0f} VNĐ"
                    )
                )
        except Exception as e:

            print("Lỗi dashboard:", e)

            ctk.CTkLabel(
                self.main_view,
                text=f"Lỗi dashboard: {str(e)}",
            text_color="red"
            ).pack(pady=50)
        
        self.after(30000, self.show_report_view)

# ==========================================
# KHỞI CHẠY HỆ THỐNG
# ==========================================
if __name__ == "__main__":
    ctk.set_appearance_mode("dark")
    
    # Khởi tạo cửa sổ Đăng nhập
    win = ctk.CTk()
    win.title("DATCOM - Đăng nhập hệ thống")
    win.geometry("400x500")
    
    # Căn giữa cửa sổ đăng nhập trên màn hình
    win.eval('tk::PlaceWindow . center')

    # Các ô nhập liệu
    ctk.CTkLabel(win, text="ĐĂNG NHẬP", font=("Arial", 24, "bold")).pack(pady=(60, 20))
    
    u = ctk.CTkEntry(win, placeholder_text="Tên đăng nhập", width=280, height=40)
    u.pack(pady=10)
    
    p = ctk.CTkEntry(win, placeholder_text="Mật khẩu", show="*", width=280, height=40)
    p.pack(pady=10)

    def login():
        user_val = u.get().strip()
        pass_val = p.get().strip()
        
        if not user_val or not pass_val:
            messagebox.showwarning("Chú ý", "Vui lòng nhập đầy đủ tài khoản và mật khẩu!")
            return

        try:
            # 1. CALL PROCEDURE: LOGIN_EMPLOYEE (Đã đúng tên và tham số)
            res = db_mgr.call_procedure("LOGIN_EMPLOYEE", (user_val, pass_val))
            
            # Kiểm tra kết quả trả về từ Procedure
            if res and res[0] and len(res[0]) > 0:
                user_data = res[0][0]
                
                # 2. Xử lý chuyển trang chuyên nghiệp:
                # Phá hủy cửa sổ Login trước khi mở App chính để giải phóng bộ nhớ
                win.destroy() 
                
                # Khởi tạo màn hình làm việc chính
                main_root = ctk.CTk()
                app = SalesApp(main_root, user_data)
                main_root.mainloop()
            else:
                messagebox.showerror("Đăng nhập thất bại", "Tài khoản hoặc mật khẩu không chính xác!")
                
        except Exception as e:
            messagebox.showerror("Lỗi kết nối Database", f"Không thể kết nối đến SQL: {str(e)}")

    # Nút Đăng nhập
    btn_login = ctk.CTkButton(win, text="ĐĂNG NHẬP", command=login, 
                              width=280, height=45, font=("Arial", 14, "bold"))
    btn_login.pack(pady=40)

    # Cho phép nhấn phím Enter để đăng nhập
    win.bind('<Return>', lambda event: login())

    win.mainloop()
from sqlalchemy import Column, Integer, String, Numeric, Date, Enum, DateTime
import datetime
from db_manager import Base

class Product(Base):
    __tablename__ = "PRODUCT"
    __table_args__ = {'extend_existing': True}

    P_CODE = Column(Integer, primary_key=True, autoincrement=True)
    P_DESCRIPT = Column(String(45), nullable=False, unique=True)
    # Cập nhật đúng các giá trị ENUM mới từ shop.sql
    P_CATEGORY = Column(Enum('ACCESSORY', 'DEVICE', 'EQUIPMENT'), nullable=False)
    P_INDATE = Column(Date, nullable=False, default=datetime.date.today)
    P_QOH = Column(Integer, nullable=False)
    P_MIN = Column(Integer, nullable=False)
    P_PRICE = Column(Numeric(9, 2), nullable=False)
    P_DISCOUNT = Column(Numeric(5, 2), nullable=False)

class Order(Base):
    __tablename__ = "INVOICE"
    __table_args__ = {'extend_existing': True}
    
    INV_NUMBER = Column(Integer, primary_key=True, autoincrement=True)
    # BƯỚC 2: Đảm bảo dùng datetime.datetime.now()
    INV_DATE = Column(DateTime, default=datetime.datetime.now) 
    INV_STATUS = Column(Enum('DRAFT', 'CANCELLED', 'PAID'), default='DRAFT')
    INV_TOTAL = Column(Numeric(9, 2), default=0.00)
    CUS_CODE = Column(Integer)
    EMP_CODE = Column(Integer)


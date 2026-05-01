from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from db_manager import Base
from datetime import datetime

class Product(Base):
    __tablename__ = 'products'
    ProductID = Column(Integer, primary_key=True, autoincrement=True)
    ProductName = Column(String(255), nullable=False)
    Price = Column(Float, nullable=False)
    StockQuantity = Column(Integer, default=0)

class Order(Base):
    __tablename__ = 'orders'
    OrderID = Column(Integer, primary_key=True, autoincrement=True)
    OrderDate = Column(DateTime, default=datetime.now)
    Status = Column(String(50), default='Pending')
    # Giả sử bảng Customers đã được bạn làm SQL tạo
    CustomerID = Column(Integer)
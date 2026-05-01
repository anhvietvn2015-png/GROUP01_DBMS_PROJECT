from models import Product, Order
from sqlalchemy.orm import Session

# 1. Tìm kiếm sản phẩm theo tên/giá (Chống SQL Injection)
def search_products(db: Session, name: str = None, min_price: float = None, max_price: float = None):
    query = db.query(Product)
    if name:
        query = query.filter(Product.ProductName.contains(name))
    if min_price is not None:
        query = query.filter(Product.Price >= min_price)
    if max_price is not None:
        query = query.filter(Product.Price <= max_price)
    return query.all()

# 2. Thêm đơn hàng mới
def create_order(db: Session, customer_id: int):
    new_order = Order(CustomerID=customer_id, Status='New')
    db.add(new_order)
    db.commit() # Lưu thay đổi vào DB
    db.refresh(new_order)
    return new_order
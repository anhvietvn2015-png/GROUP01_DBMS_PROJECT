import mysql.connector
from mysql.connector import Error
import os
from dotenv import load_dotenv

load_dotenv()

class DatabaseManager:
    def __init__(self):
        self.secret_key = os.getenv("SECRET_KEY", "@g1dbms")
        self.config = {
            'host': os.getenv("DB_HOST", "127.0.0.1"),
            'user': os.getenv("DB_USER", "shop_app"),
            'password': os.getenv("DB_PASSWORD", "group1_password"),
            'database': os.getenv("DB_NAME", "shopdb")
        }
        self.connection = None

    def connect(self):
        try:
            if not self.connection or not self.connection.is_connected():
                self.connection = mysql.connector.connect(**self.config)
            return True
        except Error: return False

    def call_procedure(self, proc_name, args):
        if not self.connect(): raise Exception("Database Offline!")
        cursor = self.connection.cursor(dictionary=True)
        try:
            cursor.callproc(proc_name, args)
            results = [r.fetchall() for r in cursor.stored_results()]
            self.connection.commit()
            return results
        except Error as e:
            self.connection.rollback()
            raise e
        finally: cursor.close()

db_mgr = DatabaseManager()
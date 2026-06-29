from dotenv import load_dotenv
import os

load_dotenv()

print("Host:", os.getenv("DB_HOST"))
print("Database:", os.getenv("DB_NAME"))
print("User:", os.getenv("DB_USER"))
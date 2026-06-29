from dotenv import load_dotenv
import os

load_dotenv()
# Print the following to verify that the .env variables are being loaded correctly
print("Host:", os.getenv("DB_HOST"))
print("Database:", os.getenv("DB_NAME"))
print("User:", os.getenv("DB_USER"))
import os
import pandas as pd
import psycopg2
from dotenv import load_dotenv  

# Explicitly resolve the absolute path to the local .env file to bypass IDE terminal restrictions
current_dir = os.path.dirname(os.path.abspath(__file__))
dotenv_path = os.path.join(current_dir, '.env')
load_dotenv(dotenv_path=dotenv_path)  

# 1. Dynamic Database Connection Parameters (Now reads from local .env successfully)
DB_PARAMS = {
    "host": os.getenv("DB_HOST", "localhost"),
    "database": os.getenv("DB_NAME", "customer_churn"),
    "user": os.getenv("DB_USER", "postgres"),
    "password": os.getenv("DB_PASSWORD", "postgres"),  # Falls back to 'postgres' if no .env match
    "port": os.getenv("DB_PORT", "5432")              # Falls back to '5432' if no .env match
}

# 2. SQL Schema Definitions
CREATE_TABLE_SQL = """
CREATE TABLE IF NOT EXISTS telco_churn (
    customer_id VARCHAR(50) PRIMARY KEY,
    gender VARCHAR(10),
    senior_citizen INT,
    partner VARCHAR(5),
    dependents VARCHAR(5),
    tenure INT,
    phone_service VARCHAR(5),
    multiple_lines VARCHAR(20),
    internet_service VARCHAR(20),
    online_security VARCHAR(20),
    online_backup VARCHAR(20),
    device_protection VARCHAR(20),
    tech_support VARCHAR(20),
    streaming_tv VARCHAR(20),
    streaming_movies VARCHAR(20),
    contract VARCHAR(20),
    paperless_billing VARCHAR(5),
    payment_method VARCHAR(40),
    monthly_charges NUMERIC(10, 2),
    total_charges TEXT, 
    churn VARCHAR(5)
);
"""

def main():
    # 3. Path to your specific copy CSV file (Using relative pathing)
    csv_path = os.path.join("data", "WA_Fn-UseC_-Telco-Customer-Churn-Copy.csv")
    print(f"Reading data from {csv_path}...")
    
    if not os.path.exists(csv_path):
        print(f"❌ Error: Could not find the dataset at {csv_path}. Make sure it's in your data/ folder!")
        return

    df = pd.read_csv(csv_path)
    
    # Clean up column headers to match lowercase SQL standards
    df.columns = [col.lower().replace('-', '_').replace(' ', '_') for col in df.columns]
    
    # 4. Connect to PostgreSQL and build the architecture
    print(f"Connecting to PostgreSQL on port {DB_PARAMS['port']}...")
    try:
        conn = psycopg2.connect(**DB_PARAMS)
        cursor = conn.cursor()
    except psycopg2.Error as e:
        print("❌ Database Connection Failed! Verify your local environment parameters match.")
        print(f"Error Details: {e}")
        return
    
    print("Creating table schema if it doesn't exist...")
    cursor.execute(CREATE_TABLE_SQL)
    conn.commit()
    
    # Clear out old data if re-running
    cursor.execute("TRUNCATE TABLE telco_churn;")
    conn.commit()
    
    # 5. Bulk insertion into the database
    print("Streaming rows into the database...")
    
    records = [tuple(x) for x in df.to_numpy()]
    
    insert_query = """
    INSERT INTO telco_churn VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s);
    """
    
    cursor.executemany(insert_query, records)
    conn.commit()
    
    # Quick validation check
    cursor.execute("SELECT COUNT(*) FROM telco_churn;")
    count = cursor.fetchone()[0]
    
    print(f"🎉 Success! Successfully ingested {count} rows into the database.")
    
    cursor.close()
    conn.close()

if __name__ == "__main__":
    main()
import os
import psycopg2
from psycopg2.extras import RealDictCursor
from openai import OpenAI
from dotenv import load_dotenv

load_dotenv()

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

# 1. DATABASE RETRIEVAL ENGINES
def fetch_customer_profile(customer_id: str):
    """Queries the feature-engineered Postgres View for deep account analytics."""
    try:
        conn = psycopg2.connect(
            host=os.getenv("DB_HOST", "localhost"),
            port=os.getenv("DB_PORT", "5432"),
            database=os.getenv("DB_NAME"),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASSWORD")
        )
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            query = "SELECT * FROM v_ml_churn_input WHERE customer_id = %s;"
            cur.execute(query, (customer_id,))
            result = cur.fetchone()
        conn.close()
        return result
    except Exception as e:
        return f"Database Fetch Error: {str(e)}"

# 2. AI AGENT MAIN RUNTIME
def run_retention_agent(user_query: str) -> str:
    """Evaluates the intent, extracts database profiles if necessary, and drafts mitigation plans."""
    
    context_data = ""
    words = user_query.split()
    potential_ids = [w for w in words if '-' in w or (len(w) >= 4 and w.isalnum())]
    
    if potential_ids:
        customer_id = potential_ids[0]
        profile = fetch_customer_profile(customer_id)
        if profile and isinstance(profile, dict):
            context_data = f"\n[CRITICAL ACCOUNT PROFILE DETECTED FOR ID {customer_id}]:\n{str(profile)}"
        elif isinstance(profile, str) and "Error" in profile:
            context_data = f"\n[Database Warning]: Could not fetch profile due to: {profile}"

    system_prompt = (
        "You are an Elite Customer Retention Strategy Agent. Your purpose is to evaluate "
        "at-risk accounts and formulate data-driven financial/contractual solutions. "
        "Use the structural SQL metrics and features provided to justify your choices. "
        "Keep responses executive, clear, and highly professional. Do not use markdown headers larger than h4."
    )

    messages = [
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": f"User Query: {user_query}\n{context_data}"}
    ]

    try:
        response = client.chat.completions.create(
            model="gpt-4o",
            messages=messages,
            temperature=0.3
        )
        return response.choices[0].message.content
    except Exception as e:
        return f"Agent Engine Timeout or API Error: {str(e)}"
from fastapi import FastAPI
import os
import psycopg2

app = FastAPI()

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME", "devopsdb")
DB_USER = os.getenv("DB_USER", "devops")
DB_PASSWORD = os.getenv("DB_PASSWORD", "devopspass")


@app.get("/")
def root():
    return {"message": "DevOps mini app is running"}


@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/db")
def check_db():
    conn = psycopg2.connect(
        host=DB_HOST,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD,
    )
    cur = conn.cursor()
    cur.execute("SELECT 'Database connection successful'")
    result = cur.fetchone()[0]
    cur.close()
    conn.close()

    return {"database": result}

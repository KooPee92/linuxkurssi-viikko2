from flask import Flask
from dotenv import load_dotenv
from pathlib import Path
import pymysql
import os

# Load database settings from .env
load_dotenv(Path(__file__).with_name(".env"))

app = Flask(__name__)


# Connect to MariaDB
def get_connection():
    return pymysql.connect(
        host=os.environ["DB_HOST"],
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
        database=os.environ["DB_NAME"]
    )


# Website homepage
@app.route("/")
def home():

    connection = get_connection()

    try:
        with connection.cursor() as cursor:

            # Increase visitor counter
            cursor.execute(
                "UPDATE visitor_counter SET visits = visits + 1 WHERE id = 1"
            )

            # Read current visitor count
            cursor.execute(
                "SELECT visits FROM visitor_counter WHERE id = 1"
            )

            visits = cursor.fetchone()[0]

        # Save changes to database
        connection.commit()

    finally:
        connection.close()

    return f"""
    <h1>Viikko 2 - Python-verkkosovellus</h1>
    <p>Flask ja MariaDB toimivat!</p>
    <p>Sivun latauksia: {visits}</p>
    """

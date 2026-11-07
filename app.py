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
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Linux Server - Week 2</title>

        <style>
            body {{
                background-color: #111827;
                color: white;
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 30px 20px;
            }}

            .container {{
                max-width: 800px;
                margin: auto;
            }}

            h1 {{
                color: #38bdf8;
                text-align: center;
            }}

            .subtitle {{
                text-align: center;
                margin-bottom: 30px;
            }}

            .card {{
                background-color: #1e293b;
                padding: 25px;
                margin-bottom: 20px;
                border-radius: 12px;
            }}

            h2 {{
                color: #38bdf8;
            }}

            .counter {{
                font-size: 48px;
                font-weight: bold;
                color: #4ade80;
                text-align: center;
            }}

            .button {{
                display: inline-block;
                background-color: #0284c7;
                color: white;
                padding: 12px 20px;
                margin: 5px;
                border-radius: 8px;
                text-decoration: none;
            }}

            .button:hover {{
                background-color: #0369a1;
            }}

            .links {{
                text-align: center;
            }}
        </style>
    </head>

    <body>
        <div class="container">

            <h1>My Linux Server - Week 2</h1>
            <p class="subtitle">
                Python Web Application and MariaDB Database
            </p>

            <div class="links">
                <a class="button" href="/">
                    Back to Week 1
                </a>

                <a class="button"
                   href="https://github.com/KooPee92/linuxkurssi-viikko2"
                   target="_blank" rel="noopener noreferrer">
                    View on GitHub
                </a>
            </div>

            <div class="card">
                <h2>1. Python Web Application</h2>
                <p>
                    This website runs on my Ubuntu Linux server
                    using Flask, Gunicorn and Nginx.
                </p>
            </div>

            <div class="card">
                <h2>2. Visitor Counter</h2>
                <p>Total page visits:</p>
                <div class="counter">{visits}</div>
                <p>The counter increases every time this page loads.</p>
            </div>

            <div class="card">
                <h2>3. MariaDB Database</h2>
                <p>
                    The visitor counter is stored in a MariaDB database.
                    The database saves the number of visits permanently.
                </p>
            </div>

            <div class="card">
                <h2>4. Restart Test</h2>
                <p>
                    Restart test has not been completed yet.
                </p>
            </div>

        </div>
    </body>
    </html>
    """

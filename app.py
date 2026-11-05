from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return """
    <h1>Viikko 2 - Python-verkkosovellus</h1>
    <p>Flask toimii!</p>
    """

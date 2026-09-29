from flask import Flask
import os

app = Flask(__name__)

@app.route("/")
def home():
    cloud = os.environ.get("CLOUD_NAME", "local")
    return f"Hello from {cloud}!"

@app.route("/health")
def health():
    return {"status": "healthy"}, 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
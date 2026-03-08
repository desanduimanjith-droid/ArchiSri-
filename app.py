# app.py - Main entry point 
from flask import Flask, jsonify
from routes.blueprint import blueprint_api  # make sure the blueprint name matches your file

app = Flask(__name__)

# Test route to confirm the backend is running
@app.route("/")
def home():
    return jsonify({
        "status": "Backend is running",
        "project": "ArchiSir - AI Blueprint Service (OpenAI Version)"
    })

# ===== Register blueprint =====
app.register_blueprint(blueprint_api)

if __name__ == "__main__":
    print("🔥 Starting Flask app...")
    app.run(debug=True)

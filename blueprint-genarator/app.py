from flask import Flask, jsonify
from routes.blueprint import blueprint_api

app = Flask(__name__)

@app.route("/")
def home():
    return jsonify({
        "status": "Backend is running",
        "project": "ArchiSir - AI Blueprint Service (OpenAI Version)"
    })

app.register_blueprint(blueprint_api)

if __name__ == "__main__":
    print("Starting Flask app...")
    app.run(debug=True, port=5002)

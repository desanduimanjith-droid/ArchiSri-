import os
from flask import Flask, jsonify
from flask_cors import CORS
from routes.blueprint import blueprint_api

app = Flask(__name__)
CORS(app)


@app.route("/")
def home():
    return jsonify({
        "status": "Backend is running",
        "project": "ArchiSir - AI Blueprint Service (OpenAI Version)"
    })


app.register_blueprint(blueprint_api)


if __name__ == "__main__":
    print("Starting Flask app...")
    port = int(os.getenv('PORT', 5002))
    debug = os.getenv('FLASK_ENV', 'production') == 'development'
    app.run(debug=debug, host="0.0.0.0", port=port)

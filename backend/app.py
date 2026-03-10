import os
import requests
from flask import Flask, request, jsonify
from flask_cors import CORS
from pathlib import Path
from dotenv import load_dotenv

import firebase_admin
from firebase_admin import credentials, auth, firestore

env_path = Path(__file__).resolve().parent / ".env"
load_dotenv(dotenv_path=env_path)

load_dotenv()

app = Flask(__name__)
CORS(app)

FIREBASE_WEB_API_KEY = os.getenv("FIREBASE_WEB_API_KEY")
print("Loaded API key:", FIREBASE_WEB_API_KEY)


if not FIREBASE_WEB_API_KEY:
    raise ValueError("FIREBASE_WEB_API_KEY not found in .env file")

if not firebase_admin._apps:
    cred = credentials.Certificate("serviceAccountKey.json")
    firebase_admin.initialize_app(cred)

db = firestore.client()


@app.route("/", methods=["GET"])
def home():
    return jsonify({"message": "Flask backend is running"}), 200


@app.route("/register", methods=["POST"])
def register():
    try:
        data = request.get_json()

        name = data.get("displayName", "").strip()
        email = data.get("email", "").strip()
        password = data.get("password", "").strip()

        if not name or not email or not password:
            return jsonify({"error": "All fields are required"}), 400

        if len(password) < 6:
            return jsonify({"error": "Password must be at least 6 characters"}), 400

        user = auth.create_user(
            email=email,
            password=password
        )

        db.collection("users").document(user.uid).set({
            "name": name,
            "email": email,
            "createdAt": firestore.SERVER_TIMESTAMP
        })

        return jsonify({
            "message": "User registered successfully",
            "uid": user.uid
        }), 201

    except auth.EmailAlreadyExistsError:
        return jsonify({"error": "Email already exists"}), 409
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/login", methods=["POST"])
def login():
    try:
        data = request.get_json()

        email = data.get("email", "").strip()
        password = data.get("password", "").strip()

        if not email or not password:
            return jsonify({"error": "Email and password are required"}), 400

        url = f"https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key={FIREBASE_WEB_API_KEY}"

        payload = {
            "email": email,
            "password": password,
            "returnSecureToken": True
        }

        response = requests.post(url, json=payload)
        result = response.json()

        if response.status_code != 200:
            error_message = result.get("error", {}).get("message", "Login failed")
            return jsonify({"error": error_message}), 401

        uid = result.get("localId")
        user_doc = db.collection("users").document(uid).get()

        user_data = user_doc.to_dict() if user_doc.exists else {}

        return jsonify({
            "message": "Login successful",
            "uid": uid,
            "email": result.get("email"),
            "name": user_data.get("name", ""),
            "idToken": result.get("idToken"),
            "refreshToken": result.get("refreshToken")
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=8000)
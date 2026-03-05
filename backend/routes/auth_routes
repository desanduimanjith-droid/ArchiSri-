from flask import request, jsonify
from routes.blueprint import blueprint_api

users = [
    {"email": "test@gmail.com", "password": "123456"}
]

@blueprint_api.route("/login", methods=["POST"])
def login():

    data = request.get_json()

    email = data.get("email")
    password = data.get("password")

    for user in users:
        if user["email"] == email and user["password"] == password:
            return jsonify({
                "message": "Login successful",
                "email": email
            }), 200

    return jsonify({
        "message": "Invalid email or password"
    }), 401
from flask import Flask
from blueprint_api import blueprint_api

app = Flask(__name__)
app.register_blueprint(blueprint_api)

if __name__ == "__main__":
    app.run(debug=True)

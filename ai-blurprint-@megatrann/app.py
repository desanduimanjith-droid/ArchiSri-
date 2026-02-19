from flask import Flask
from diffusers import StableDiffusionPipeline
import torch
from huggingface_hub import login

# 🔐 Hardcode token (temporary)
login(token="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")

# Load model ONCE at server start
model_id = "runwayml/stable-diffusion-v1-5"

print("Loading diffusion model...")
pipe = StableDiffusionPipeline.from_pretrained(model_id)
pipe = pipe.to("cpu")   # change to "cuda" if GPU available
print("Model loaded successfully!")

# Create Flask app
app = Flask(__name__)

# Import blueprint AFTER model load
from blueprint_api import blueprint_api

# Attach pipeline so blueprint can use it
app.config["PIPELINE"] = pipe

# Register blueprint
app.register_blueprint(blueprint_api)

if __name__ == "__main__":
    app.run(debug=True)

import os
from flask import Blueprint, request, jsonify
import requests
from io import BytesIO
from PIL import Image

blueprint_api = Blueprint("blueprint_api",__name__) #used to organize routes

HF_API_KEY = os.getenv("HF_API_KEY")
print("HF API KEY LOADED:",HF_API_KEY is not None)
HF_MODEL_URL = "https://router.huggingface.co/models/runwayml/stable-diffusion-v1-5"

@blueprint_api.route("/generate-blueprint",methods=["POST"])
def generate_blueprint():
    data = request.json # Get the JSON data sent from the client (frontend / Postman)
    land_width = data.get("land_width")
    land_length = data.get("land_length")
    bedrooms = data.get("bedrooms")
    enviroment = data.get("environment")

    propmt = f"""
    2D architectural floor plan blureprint,
    residential house design,
    {bedrooms}bedrooms,
    land size {land_width} x {land_length} feet,
    suitable for {enviroment} environmnet in sri lanka,
    top down view,
    black and white technical drwing,
    clean lines,
    labled rooms
    """

    header = {
        "Authorization":f"Bearer {HF_API_KEY}"
    }

    payload = {
        "inputs":propmt
    }

    response = requests.post(HF_MODEL_URL,headers=header,json=payload)

    if response.status_code !=200:
        return jsonify({
            "success":False,
            "error":"Diffusion model failed",
            "details":response.text
        }),500
    
    image = Image.open(BytesIO(response.content))
    image_path = "static/generated_plan.png"
    image.save(image_path)

    return jsonify({
        "success":True,
        "message":"AI Blueprint generated successfully",
        "image_path":image_path,
        "ai_model":"Stable Diffusion (Hugging face)"
    })
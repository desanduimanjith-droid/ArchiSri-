import os
import base64
from io import BytesIO
from flask import Blueprint, request, send_file, jsonify
from openai import OpenAI

blueprint_api = Blueprint("blueprint_api", __name__)

OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

if not OPENAI_API_KEY:
    raise RuntimeError("OPENAI_API_KEY not set")

client = OpenAI(api_key=OPENAI_API_KEY)

# Function to build the prompt for the image generation
def build_prompt(num_floors, style, landsize, bedrooms=None, bathrooms=None, kitchen=None, living_room=None):

    return f"""
Professional architectural floor plan sheet.

White background blueprint style.
Clean black CAD line drawing.

Layout rules:
- large margins around drawing
- nothing cropped
- floors arranged vertically
- title at top
- legend and scale at bottom

Drawing style:
- technical architectural blueprint
- consistent wall thickness
- door swing arcs
- windows clearly marked
- dimension lines in feet
- professional architectural symbols

Architecture logic:
- realistic residential planning
- correct circulation paths
- stairs connecting floors
- balanced room layout

Ground Floor requirements:
garage with a top view car parked inside
entrance foyer
living room
kitchen
dining area
staircase
hallway circulation

Garage details:
- show a realistic car top view inside the garage
- car properly scaled to fit the garage
- driveway connected to garage entrance

Upper Floors:
bedrooms
bathrooms
corridor
stair landing

Room proportions:
bedrooms 10-14 ft
corridors 3-4 ft
garage fits one car

Project information:
Style: {style}
Land size: {landsize} square feet
Bedrooms: {bedrooms or "not specified"}
Bathrooms: {bathrooms or "not specified"}
Kitchen: {kitchen or "not specified"}
Living room: {living_room or "not specified"}

Generate {num_floors} floors.

Label floors clearly:
FLOOR 1
FLOOR 2
FLOOR 3

Entire drawing must fit inside the page with no cropping.
"""

# API route to generate blueprint
@blueprint_api.route("/blueprint", methods=["POST"])
def generate_blueprint():

    try:

        data = request.json or {}

        landsize = data.get("landsize")
        floors = data.get("floors")
        style = data.get("style")

        if not landsize or not floors or not style:
            return jsonify({
                "success": False,
                "error": "landsize, floors, style required"
            }), 400

        bedrooms = data.get("bedrooms")
        bathrooms = data.get("bathrooms")
        kitchen = data.get("kitchen")
        living_room = data.get("living_room")

        num_floors = int(floors)

        prompt = build_prompt(
            num_floors,
            style,
            landsize,
            bedrooms,
            bathrooms,
            kitchen,
            living_room
        )

        result = client.images.generate(
            model="dall-e-3",
            prompt=prompt,
            size="1024x1792", # portrait orientation for floor plans
            response_format="b64_json"
        )

        image_base64 = result.data[0].b64_json # get the base64 string from the response
        image_bytes = base64.b64decode(image_base64) # decode the base64 string to bytes

        # Send the image bytes as a file response
        return send_file(
            BytesIO(image_bytes),
            mimetype="image/png",
            as_attachment=True,
            download_name="architectural_blueprint.png"
        )
    
    # Handle any exceptions and return an error response
    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500

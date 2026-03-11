import os
import base64
from io import BytesIO
from pathlib import Path
from flask import Blueprint, request, send_file, jsonify
from openai import OpenAI
from dotenv import load_dotenv

load_dotenv(dotenv_path=Path(__file__).resolve().parents[1] / ".env")

blueprint_api = Blueprint("blueprint_api", __name__)

def _resolve_openai_api_key() -> str | None:
    return os.getenv("OPENAI_API_KEY") or os.getenv("BLUEPRINT_OPENAI_API_KEY")


def _get_openai_client() -> OpenAI | None:
    api_key = _resolve_openai_api_key()
    if not api_key:
        return None
    return OpenAI(api_key=api_key)


def build_prompt(floors, style, landsize, bedrooms, bathrooms, kitchen, living_room):

    floor_labels = ""
    for i in range(1, floors + 1):
        floor_labels += f"FLOOR {i}\n"

    return f"""
Create a PROFESSIONAL ARCHITECTURAL FLOOR PLAN PRESENTATION SHEET.

IMPORTANT: The page design must remain identical every generation.

PAGE FRAME
- white paper background
- thin black architectural border around the page
- large margins
- nothing cropped

TITLE AT TOP CENTER
ARCHITECTURAL FLOOR PLAN

DRAWING AREA
Floors stacked vertically and labeled:

{floor_labels}

Each floor inside its own rectangular drawing area.

DRAWING STYLE
- black CAD architectural line drawing
- thin precise lines
- consistent wall thickness
- door swing arcs
- window symbols
- stair arrows
- dimension text in feet

GROUND FLOOR CONTENT
garage with top-view car
entrance foyer
living room
kitchen
dining
stairs
hallway circulation

UPPER FLOORS CONTENT
bedrooms
bathrooms
corridor
stair landing

ROOM SIZE GUIDELINES
bedrooms 10–14 ft
bathrooms 5–8 ft
corridors 3–4 ft
garage fits 1 car

CLIENT REQUIREMENTS

Style: {style}
Land size: {landsize} square feet
Bedrooms: {bedrooms}
Bathrooms: {bathrooms}
Kitchen: {kitchen}
Living room: {living_room}

BOTTOM RIGHT INFO BOX

Style: {style}
Land size: {landsize} square feet
Bedrooms: {bedrooms}
Bathrooms: {bathrooms}
Kitchen: {kitchen}
Living room: {living_room}

BOTTOM LEFT SCALE BAR

1/4" = 1'-0"

IMPORTANT RULES

- identical sheet layout every time
- only the room arrangement changes
- floors vertically aligned
- professional architectural blueprint sheet
- entire drawing fits inside border

Generate {floors} floors according to the client requirements.
"""


@blueprint_api.route("/blueprint", methods=["POST"])
def generate_blueprint():
    try:
        client = _get_openai_client()
        if client is None:
            return jsonify({
                "success": False,
                "error": "Missing API key. Set OPENAI_API_KEY or BLUEPRINT_OPENAI_API_KEY in environment."
            }), 500

        data = request.json or {}

        landsize = data.get("landsize")
        floors = int(data.get("floors", 2))
        style = data.get("style")

        bedrooms = data.get("bedrooms", 3)
        bathrooms = data.get("bathrooms", 2)
        kitchen = data.get("kitchen", 1)
        living_room = data.get("living_room", 1)

        if not landsize or not style:
            return jsonify({
                "success": False,
                "error": "landsize and style required"
            }), 400

        prompt = build_prompt(
            floors,
            style,
            landsize,
            bedrooms,
            bathrooms,
            kitchen,
            living_room
        )

        result = client.images.generate(
            model="gpt-image-1",
            prompt=prompt,
            size="1024x1536"
        )

        image_base64 = result.data[0].b64_json
        image_bytes = base64.b64decode(image_base64)

        return send_file(
            BytesIO(image_bytes),
            mimetype="image/png",
            as_attachment=True,
            download_name="architectural_blueprint.png"
        )

    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500
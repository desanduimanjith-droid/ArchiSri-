import os
import base64
from io import BytesIO
from flask import Blueprint, request, send_file, jsonify
from openai import OpenAI
from dotenv import load_dotenv

blueprint_api = Blueprint("blueprint_api", __name__)

load_dotenv()

OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

if not OPENAI_API_KEY:
    raise RuntimeError("OPENAI_API_KEY not set")

client = OpenAI(api_key=OPENAI_API_KEY)


def _format_list(values):
    if not values:
        return "None"
    return ", ".join(str(v) for v in values)


def _format_map(values):
    if not values:
        return "None"

    parts = []
    for key, entries in values.items():
        parts.append(f"- {key}: {_format_list(entries)}")
    return "\n".join(parts)


def build_prompt(
    floors,
    style,
    landsize,
    bedrooms,
    bathrooms,
    kitchen,
    living_room,
    selected_floors=None,
    bathroom_type_selections=None,
    kitchen_floor_selections=None,
    bedroom_selections_by_floor=None,
    bathroom_selections_by_floor=None,
    living_room_selections_by_floor=None,
):

    floor_labels = ""
    for i in range(1, floors + 1):
        floor_labels += f"FLOOR {i}\n"

    return f"""
Create a PROFESSIONAL ARCHITECTURAL FLOOR PLAN PRESENTATION SHEET.

IMPORTANT: The page frame and title style must remain consistent every generation.

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

MANDATORY DEFAULT CONTENT
- FLOOR 1 must include one garage with a top-view car symbol.

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

DETAILED USER INPUTS

Selected floor option(s): {_format_list(selected_floors)}
Bathroom type preference(s): {_format_list(bathroom_type_selections)}
Kitchen floor preference(s): {_format_list(kitchen_floor_selections)}

Bedrooms selected by floor:
{_format_map(bedroom_selections_by_floor)}

Bathrooms selected by floor:
{_format_map(bathroom_selections_by_floor)}

Living rooms selected by floor:
{_format_map(living_room_selections_by_floor)}

PROGRAM RULES (STRICT)

- Use user requirements as the source of truth for room program and distribution.
- Do NOT add extra room types or default spaces unless required by user inputs.
- Keep only the mandatory default: first-floor garage with top-view car.
- Floor count, room counts, and per-floor placement must follow user-provided values.
- If a floor has no user-selected room for a category, do not invent one.

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

- keep sheet layout, frame, and title consistent
- floors vertically aligned
- professional architectural blueprint sheet
- entire drawing fits inside border
- room program must reflect user requirements, not default layout assumptions

Generate {floors} floors according to the client requirements.
"""


@blueprint_api.route("/blueprint", methods=["POST"])
def generate_blueprint():
    try:

        data = request.json or {}

        landsize = data.get("landsize")
        floors = int(data.get("floors", 2))
        style = data.get("style")

        bedrooms = data.get("bedrooms", 3)
        bathrooms = data.get("bathrooms", 2)
        kitchen = data.get("kitchen", 1)
        living_room = data.get("living_room", 1)
        selected_floors = data.get("selected_floors", [])
        bathroom_type_selections = data.get("bathroom_type_selections", [])
        kitchen_floor_selections = data.get("kitchen_floor_selections", [])
        bedroom_selections_by_floor = data.get("bedroom_selections_by_floor", {})
        bathroom_selections_by_floor = data.get("bathroom_selections_by_floor", {})
        living_room_selections_by_floor = data.get("living_room_selections_by_floor", {})

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
            living_room,
            selected_floors,
            bathroom_type_selections,
            kitchen_floor_selections,
            bedroom_selections_by_floor,
            bathroom_selections_by_floor,
            living_room_selections_by_floor,
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
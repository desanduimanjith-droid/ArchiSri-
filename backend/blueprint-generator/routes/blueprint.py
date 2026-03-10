# routes/blueprint.py
import os
import base64
from flask import Blueprint, request, send_file, jsonify
from openai import OpenAI

print("routes/blueprint.py loaded")

# ===== Blueprint instance =====
blueprint_api = Blueprint("blueprint_api", __name__)

# ===== OpenAI client =====
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", "")
client = OpenAI(api_key=OPENAI_API_KEY) if OPENAI_API_KEY else None

# ===== Helper: build prompt =====
def build_prompt(floor_number, num_floors, style, landsize, bedrooms=None, bathrooms=None, kitchen=None, living_room=None):
    return f"""
    PROFESSIONAL ARCHITECTURAL BLUEPRINT
    Top-down 2D CAD floor plan.
    Black and white line drawing.
    Clean layout, labeled rooms, realistic proportions.

    Style: {style}
    Land size: {landsize} sq ft
    Floor: {floor_number} of {num_floors}
    Bedrooms: {bedrooms or 'N/A'}
    Bathrooms: {bathrooms or 'N/A'}
    Kitchen: {kitchen or 'N/A'}
    Living Room: {living_room or 'N/A'}
    """

# ===== Route =====
@blueprint_api.route("/blueprint", methods=["POST"])
def generate_blueprint():
    try:
        data = request.json or {}

        # ===== Required fields =====
        landsize = data.get("landsize")
        floors = data.get("floors")
        style = data.get("style")

        if not landsize or not floors or not style:
            return jsonify({
                "success": False,
                "error": "landsize, floors, and style are required"
            }), 400

        # Optional fields
        bedrooms = data.get("bedrooms")
        bathrooms = data.get("bathrooms")
        kitchen = data.get("kitchen")
        living_room = data.get("living_room")

        # Validate floors
        try:
            num_floors = int(floors)
            if num_floors <= 0:
                return jsonify({"success": False, "error": "floors must be positive"}), 400
        except:
            return jsonify({"success": False, "error": "invalid floors value"}), 400

        generated_files = []

        # ===== Generate images =====
        if not client:
            return jsonify({"success": False, "error": "OpenAI API key is missing on the backend"}), 500

        for floor_number in range(1, num_floors + 1):
            prompt = build_prompt(floor_number, num_floors, style, landsize, bedrooms, bathrooms, kitchen, living_room)

            result = client.images.generate(
                model="gpt-image-1",
                prompt=prompt,
                size="1024x1024"
            )

            image_base64 = result.data[0].b64_json
            image_bytes = base64.b64decode(image_base64)
            file_path = f"floor_{floor_number}.png"

            with open(file_path, "wb") as f:
                f.write(image_bytes)

            generated_files.append(file_path)

        # ===== Return result =====
        if num_floors == 1:
            return send_file(generated_files[0], mimetype="image/png")

        # Multiple floors: return Base64 JSON
        images_base64 = []
        for f in generated_files:
            with open(f, "rb") as img_file:
                images_base64.append(base64.b64encode(img_file.read()).decode("utf-8"))

        return jsonify({
            "success": True,
            "floors_generated": num_floors,
            "images_base64": images_base64
        })

    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500
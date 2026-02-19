import os
from flask import Blueprint, request, send_file, jsonify, current_app
from PIL import Image, ImageDraw, ImageFont, ImageFilter, ImageStat


blueprint_api = Blueprint("blueprint_api", __name__)

# Get token from environment variable (SAFE way)
HF_TOKEN = "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"


@blueprint_api.route("/generate-blueprint", methods=["POST"])
def generate_blueprint():
    try:
        data = request.json
        
        # ===== INPUT VALIDATION =====
        # Extract all input parameters
        landsize = data.get("landsize")
        bedrooms = data.get("bedrooms")
        floors = data.get("floors")
        bathrooms = data.get("bathrooms")
        living_room = data.get("living_room")
        kitchen = data.get("kitchen")
        style = data.get("style")
        
        # Validate required fields are present
        required_fields = {
            "landsize": landsize,
            "floors": floors,
            "style": style
        }
        
        missing_fields = [field for field, value in required_fields.items() if value is None or str(value).strip() == ""]
        if missing_fields:
            return jsonify({
                "success": False,
                "error": f"Missing required fields: {', '.join(missing_fields)}"
            }), 400
        
        # Convert and validate floors to positive integer
        try:
            num_floors = int(floors)
            if num_floors <= 0:
                return jsonify({
                    "success": False,
                    "error": "Number of floors must be a positive integer (greater than 0)"
                }), 400
        except (ValueError, TypeError):
            return jsonify({
                "success": False,
                "error": f"Invalid floors value: '{floors}'. Must be a positive integer"
            }), 400
        
        # Validate room data - at least one room type should be present
        room_data = {
            "bedrooms": bedrooms,
            "bathrooms": bathrooms,
            "living_room": living_room,
            "kitchen": kitchen
        }
        
        if not any(room_data.values()):
            return jsonify({
                "success": False,
                "error": "At least one room type (bedrooms, bathrooms, living_room, or kitchen) must be specified"
            }), 400
        
        # ===== START BLUEPRINT GENERATION =====

        def compute_sharpness(pil_img):
            """Compute a simple sharpness/clarity score for an image.
            Uses edge detection (FIND_EDGES) and returns mean edge intensity.
            Higher means sharper.
            """
            try:
                gray = pil_img.convert("L")
                edges = gray.filter(ImageFilter.FIND_EDGES)
                stat = ImageStat.Stat(edges)
                return stat.mean[0] if stat.mean else 0
            except Exception:
                return 0

        def get_prompt_template(style, landsize, floor_num, num_floors, bedrooms, bathrooms, kitchen, living_room):
            """Return a reusable, architecture-optimized prompt template."""
            return (
                f"Floor {floor_num} Plan\n"
                "PROFESSIONAL ARCHITECTURAL DRAFT - CAD STYLE\n\n"
                "Instructions:\n"
                "- View: Top-down orthographic floor plan (2D plan view only).\n"
                "- Drafting style: Professional architectural CAD drawing, black-and-white linework.\n"
                "- Clarity: Clean layout, no artistic shading.\n\n"
                "Project Parameters:\n"
                f"- Style: {style}\n"
                f"- Land size: {landsize} sq ft\n"
                f"- Floor designation: Floor {floor_num} of {num_floors}\n"
                f"- Bedrooms: {bedrooms}\n"
                f"- Bathrooms: {bathrooms}\n"
                f"- Kitchen: {kitchen}\n"
                f"- Living room: {living_room}\n"
            )

        # Generate multiple variations of each floor blueprint
        floor_images = []
        num_variations = 2
        
        for floor_num in range(1, num_floors + 1):
            floor_prompt = get_prompt_template(style, landsize, floor_num, num_floors, bedrooms, bathrooms, kitchen, living_room)

            floor_variations = {
                "floor": floor_num,
                "variations": []
            }

            for variation_num in range(1, num_variations + 1):

                negative_prompt = (
                    "blur, distortion, painterly, messy layout,"
                    " low detail, color gradients, shadows, perspective, 3d"
                )

                # 🔥 USE LOCAL DIFFUSERS PIPELINE FROM app.py
                pipe = current_app.config["PIPELINE"]

                floor_image = pipe(
                    prompt=floor_prompt,
                    negative_prompt=negative_prompt,
                    num_inference_steps=50,
                    guidance_scale=7.5
                ).images[0]

                floor_variations["variations"].append({
                    "variation": variation_num,
                    "image": floor_image.convert("RGBA")
                })

            floor_images.append(floor_variations)
        
        # Select sharpest variation
        labeled_floor_images = []
        for floor_item in floor_images:
            best_score = -1
            best_variation_image = None

            for variation_item in floor_item["variations"]:
                score = compute_sharpness(variation_item["image"])
                if score > best_score:
                    best_score = score
                    best_variation_image = variation_item["image"]

            labeled_floor_images.append({
                "floor": floor_item["floor"],
                "image": best_variation_image
            })
        
        # Save images
        png_paths = []
        for floor_item in labeled_floor_images:
            floor_path = f"generated_plan_floor_{floor_item['floor']}.png"
            floor_item["image"].save(floor_path)
            png_paths.append(floor_path)

        return send_file(png_paths[0], mimetype="image/png")

    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500

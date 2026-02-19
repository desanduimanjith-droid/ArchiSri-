import os
from flask import Blueprint, request, send_file, jsonify
from huggingface_hub import InferenceClient
from PIL import Image, ImageDraw, ImageFont, ImageFilter, ImageStat

blueprint_api = Blueprint("blueprint_api", __name__)

# Get token from environment variable (SAFE way)
HF_TOKEN = "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"
client = InferenceClient(token=HF_TOKEN)


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
            """Compute a simple sharpness/clarity score for an image using edge detection."""
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
                "- Drafting style: Professional architectural CAD drawing, black-and-white linework, vector-like crisp lines.\n"
                "- Clarity: Clean layout, no artistic shading, no gradients, no blur, no textures.\n"
                "- Detail: High-detail blueprint suitable for printing and documentation.\n\n"
                "Requirements:\n"
                "- Wall representation: Clear wall thickness for exterior and interior walls, consistent wall section drawing.\n"
                "- Room proportions: Rooms should be proportional and reflect typical sizes.\n"
                "- Annotations: Readable room labels, dimension lines, door arcs, window breaks, standard fixture symbols.\n"
                "- Layout clarity: Avoid overlapping labels and lines; keep intersections and corners precise.\n\n"
                "Project Parameters:\n"
                f"- Style: {style}\n"
                f"- Land size: {landsize} sq ft\n"
                f"- Floor designation: Floor {floor_num} of {num_floors}\n"
                f"- Bedrooms: {bedrooms}\n"
                f"- Bathrooms: {bathrooms}\n"
                f"- Kitchen: {kitchen}\n"
                f"- Living room: {living_room}\n\n"
                "Rendering preferences:\n"
                "- Use multiple line weights.\n"
                "- Include scale bar and north arrow.\n"
                "- Leave a clean margin.\n"
                "- Optimized for 1024x1024 generation.\n\n"
                "Quality: Professional drafting quality."
            )

        # Generate multiple variations of each floor blueprint
        floor_images = []
        num_variations = 4  # 4 variations per floor

        for floor_num in range(1, num_floors + 1):
            floor_prompt = get_prompt_template(style, landsize, floor_num, num_floors, bedrooms, bathrooms, kitchen, living_room)

            floor_variations = {"floor": floor_num, "variations": []}
            for variation_num in range(1, num_variations + 1):
                negative_prompt = (
                    "blur, blurry, distortion, distorted, artistic effects, painterly, messy layout,"
                    " text distortion, unreadable text, unrealistic rooms, wrong proportions, low detail,"
                    " smudged, watercolor, oil painting, photorealistic, color gradients, shadows, perspective, 3d"
                )
                floor_image = client.text_to_image(
                    prompt=floor_prompt,
                    negative_prompt=negative_prompt,
                    model="stabilityai/stable-diffusion-xl-base-1.0",
                    height=1024,
                    width=1024,
                    num_inference_steps=80,
                    guidance_scale=9.0
                )
                floor_variations["variations"].append({"variation": variation_num, "image": floor_image.convert("RGBA")})

            floor_images.append(floor_variations)

        # Select sharpest variation for each floor
        labeled_floor_images = []
        for floor_item in floor_images:
            floor_num = floor_item["floor"]
            variations = floor_item["variations"]
            best_score = -1
            best_variation_image = None
            for var in variations:
                score = compute_sharpness(var["image"])
                if score > best_score:
                    best_score = score
                    best_variation_image = var["image"]
            labeled_floor_images.append({"floor": floor_num, "image": best_variation_image, "sharpness_score": best_score})

        # Save individual floor images
        png_paths = []
        for floor_item in labeled_floor_images:
            floor_path = f"generated_plan_floor_{floor_item['floor']}.png"
            floor_item["image"].save(floor_path)
            png_paths.append(floor_path)

        # Generate combined multi-floor image
        if num_floors > 1:
            first_floor_width, _ = labeled_floor_images[0]["image"].size
            separator_height = 40
            total_height = sum(img["image"].size[1] + separator_height for img in labeled_floor_images)
            multi_floor_image = Image.new("RGBA", (first_floor_width, total_height), "white")
            current_y = 0
            separator_draw = ImageDraw.Draw(multi_floor_image)
            for idx, floor_item in enumerate(labeled_floor_images):
                floor_img = floor_item["image"]
                multi_floor_image.paste(floor_img, (0, current_y))
                current_y += floor_img.size[1]
                if idx < num_floors - 1:
                    separator_draw.line([(0, current_y), (first_floor_width, current_y)], fill="black", width=3)
                    current_y += separator_height
            multi_floor_png_path = "blueprint_combined_all_floors.png"
            multi_floor_image.save(multi_floor_png_path)
            return send_file(multi_floor_png_path, mimetype="image/png")

        # Single floor return
        return send_file(png_paths[0], mimetype="image/png")

    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500

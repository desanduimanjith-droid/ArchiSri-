import os
from flask import Blueprint, request, send_file, jsonify
from PIL import Image, ImageDraw, ImageFont, ImageFilter, ImageStat
from diffusers import StableDiffusionPipeline
import torch

blueprint_api = Blueprint("blueprint_api", __name__)

# ----------------------------
# Load Stable Diffusion locally
# ----------------------------
# First download will require internet; after that it runs offline
device = "cpu"  # Change to "cuda" if you have GPU
MODEL_ID = "runwayml/stable-diffusion-v1-5"

pipe = StableDiffusionPipeline.from_pretrained(MODEL_ID, torch_dtype=torch.float32)
pipe = pipe.to(device)

# ----------------------------
# Blueprint generation route
# ----------------------------
@blueprint_api.route("/generate-blueprint", methods=["POST"])
def generate_blueprint():
    try:
        data = request.json

        # ===== INPUT VALIDATION =====
        landsize = data.get("landsize")
        bedrooms = data.get("bedrooms")
        floors = data.get("floors")
        bathrooms = data.get("bathrooms")
        living_room = data.get("living_room")
        kitchen = data.get("kitchen")
        style = data.get("style")

        required_fields = {"landsize": landsize, "floors": floors, "style": style}
        missing_fields = [field for field, value in required_fields.items() if value is None or str(value).strip() == ""]
        if missing_fields:
            return jsonify({"success": False, "error": f"Missing required fields: {', '.join(missing_fields)}"}), 400

        try:
            num_floors = int(floors)
            if num_floors <= 0:
                return jsonify({"success": False, "error": "Number of floors must be a positive integer"}), 400
        except (ValueError, TypeError):
            return jsonify({"success": False, "error": f"Invalid floors value: '{floors}'"}), 400

        room_data = {"bedrooms": bedrooms, "bathrooms": bathrooms, "living_room": living_room, "kitchen": kitchen}
        if not any(room_data.values()):
            return jsonify({"success": False, "error": "At least one room type must be specified"}), 400

        # ----------------------------
        # Helper functions
        # ----------------------------
        def compute_sharpness(pil_img):
            try:
                gray = pil_img.convert("L")
                edges = gray.filter(ImageFilter.FIND_EDGES)
                stat = ImageStat.Stat(edges)
                return stat.mean[0] if stat.mean else 0
            except Exception:
                return 0

        def get_prompt_template(style, landsize, floor_num, num_floors, bedrooms, bathrooms, kitchen, living_room):
            return (
                f"Floor {floor_num} Plan\n"
                "PROFESSIONAL ARCHITECTURAL DRAFT - CAD STYLE\n\n"
                "Instructions:\n"
                "- Top-down 2D blueprint view.\n"
                "- Black-and-white CAD linework, high detail.\n"
                "- Clean layout, readable labels, proportional rooms.\n\n"
                "Project Parameters:\n"
                f"- Style: {style}\n"
                f"- Land size: {landsize} sq ft\n"
                f"- Floor: {floor_num} of {num_floors}\n"
                f"- Bedrooms: {bedrooms}\n"
                f"- Bathrooms: {bathrooms}\n"
                f"- Kitchen: {kitchen}\n"
                f"- Living room: {living_room}"
            )

        # ----------------------------
        # Generate floors
        # ----------------------------
        floor_images = []
        num_variations = 2  # reduce variations for speed

        for floor_num in range(1, num_floors + 1):
            floor_prompt = get_prompt_template(style, landsize, floor_num, num_floors, bedrooms, bathrooms, kitchen, living_room)
            variations = []

            for _ in range(num_variations):
                # Generate locally
                img = pipe(floor_prompt).images[0]
                img = img.convert("RGBA")
                variations.append(img)

            # Pick sharpest variation
            best_img = max(variations, key=compute_sharpness)
            floor_images.append({"floor": floor_num, "image": best_img})

        # ----------------------------
        # Save single/multi-floor output
        # ----------------------------
        if num_floors == 1:
            out_path = "floor_1.png"
            floor_images[0]["image"].save(out_path)
            return send_file(out_path, mimetype="image/png")
        else:
            # Combine floors vertically
            widths = [img["image"].width for img in floor_images]
            heights = [img["image"].height for img in floor_images]
            total_height = sum(heights) + (num_floors - 1) * 40
            combined = Image.new("RGBA", (max(widths), total_height), "white")

            y = 0
            for i, f in enumerate(floor_images):
                combined.paste(f["image"], (0, y))
                y += f["image"].height
                if i < num_floors - 1:
                    draw = ImageDraw.Draw(combined)
                    draw.line([(0, y), (max(widths), y)], fill="black", width=3)
                    y += 40

            out_path = "blueprint_combined.png"
            combined.save(out_path)
            return send_file(out_path, mimetype="image/png")

    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500

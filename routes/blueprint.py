import os
from flask import Blueprint, request, send_file, jsonify
from huggingface_hub import InferenceClient
from PIL import ImageDraw, ImageFont


blueprint_api = Blueprint("blueprint_api", __name__)

# Get token from environment variable (SAFE way)
HF_TOKEN = "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"

client = InferenceClient(token=HF_TOKEN)

@blueprint_api.route("/generate-blueprint", methods=["POST"])
def generate_blueprint():
    try:
        data = request.json

        landsize = data.get("landsize")
        bedrooms = data.get("bedrooms")
        floors = data.get("floors")
        bathrooms = data.get("bathrooms")
        living_room = data.get("living_room")
        kitchen = data.get("kitchen")
        style = data.get("style")


        prompt = f"""
        2D architectural floor plan blueprint,
        top view,
        technical CAD drawing,
        land size {landsize},
        bedrooms {bedrooms},
        floors {floors},
        kitchen {kitchen},
        living room {living_room},
        bathrooms {bathrooms},
        style {style}
        accurate room dimensions,
        black and white blueprint style,
        clean layout,
        high resolution,
        professional architectural drafting
        """

        image = client.text_to_image(
            prompt=prompt,
            model="stabilityai/stable-diffusion-xl-base-1.0"
        )

        #Convert the editable format
        image = image.convert("RGBA")
        draw = ImageDraw.Draw(image)
        try:
            font_large = ImageFont.truetype("arial.ttf", 20)
            font_small = ImageFont.truetype("arial.ttf", 15)
        except:
            font_large = ImageFont.load_default()
            font_small = ImageFont.load_default()
        
        # 🔹 HEADER INFO
        draw.text((50, 50), f"Land Size: {landsize}", fill="black", font=font_large)
        draw.text((50, 120), f"Floors: {floors}", fill="black", font=font_small)

        # 🔹 ROOM LABELS + DIMENSIONS
        y_position = 200

        if bedrooms:
            draw.text((50, y_position), f"Bedrooms: {bedrooms} (12x12 ft each)", fill="black", font=font_small)
            y_position += 60

        if bathrooms:
            draw.text((50, y_position), f"Bathrooms: {bathrooms} (8x6 ft each)", fill="black", font=font_small)
            y_position += 60

        if kitchen:
            draw.text((50, y_position), f"Kitchen: {kitchen} (10x8 ft)", fill="black", font=font_small)
            y_position += 60

        if living_room:
            draw.text((50, y_position), f"Living Room: {living_room} (15x12 ft)", fill="black", font=font_small)
            y_position += 60

        draw.text((50, y_position), f"Style: {style}", fill="black", font=font_small)

        #Save the image
        image_path = "generated_plan.png"
        image.save(image_path)

        return send_file(image_path, mimetype="image/png")

    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500

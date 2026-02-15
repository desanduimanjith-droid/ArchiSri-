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
            """Compute a simple sharpness/clarity score for an image.
            Uses edge detection (FIND_EDGES) and returns mean edge intensity.
            Higher means sharper.
            """
            try:
                gray = pil_img.convert("L")
                edges = gray.filter(ImageFilter.FIND_EDGES)
                stat = ImageStat.Stat(edges)
                # Use mean edge intensity as sharpness score
                return stat.mean[0] if stat.mean else 0
            except Exception:
                return 0

        def get_prompt_template(style, landsize, floor_num, num_floors, bedrooms, bathrooms, kitchen, living_room):
            """Return a reusable, architecture-optimized prompt template.

            This template enforces professional architectural drafting, CAD style,
            clear room proportions, dimension hints, layout clarity, top view and
            high-detail blueprint output. It is intended to be used for every
            image generation request.
            """
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
                "- Room proportions: Rooms should be proportional and reflect typical sizes for given counts (hint: bedroom ~10-14 ft, bathroom ~5-8 ft, living ~12-20 ft, kitchen ~8-12 ft).\n"
                "- Annotations: Readable room labels (centered, horizontal), dimension lines (feet-inches), door swing arcs, window breaks, and standard fixture symbols.\n"
                "- Dimensions hints: Provide wall-to-wall dimensions, room dimensions inside spaces, and overall building perimeter dimensions; use architectural notation.\n"
                "- Layout clarity: Avoid overlapping labels and lines; keep intersections and corners precise with correct line weights.\n\n"
                "Project Parameters:\n"
                f"- Style: {style}\n"
                f"- Land size: {landsize} sq ft\n"
                f"- Floor designation: Floor {floor_num} of {num_floors}\n"
                f"- Bedrooms: {bedrooms}\n"
                f"- Bathrooms: {bathrooms}\n"
                f"- Kitchen: {kitchen}\n"
                f"- Living room: {living_room}\n\n"
                "Rendering preferences:\n"
                "- Use multiple line weights (thick exterior, medium interior, thin dimensions/grid).\n"
                "- Include a small scale bar and north arrow in a corner.\n"
                "- Leave a clean margin on the right for external notes (do not draw a textual legend on the plan).\n"
                "- Produce output optimized for 1024x1024 generation with high fidelity.\n\n"
                "Quality: Professional drafting quality - suitable for client presentation and contractor reference.\n"
            )

        # Generate multiple variations of each floor blueprint
        floor_images = []
        num_variations = 4  # Generate 4 variations per floor for best selection
        
        for floor_num in range(1, num_floors + 1):
            # Create floor-specific prompt with maximum detail for professional CAD output
            floor_prompt = get_prompt_template(style, landsize, floor_num, num_floors, bedrooms, bathrooms, kitchen, living_room)

            # Generate multiple variations for this floor
            floor_variations = {
                "floor": floor_num,
                "variations": []
            }

            for variation_num in range(1, num_variations + 1):
                # Generate high-resolution image variation for this floor
                # Request higher-quality settings: 1024x1024, increased steps and guidance for clarity
                negative_prompt = (
                    "blur, blurry, distortion, distorted, artistic effects, painterly, messy layout,"
                    " text distortion, unreadable text, unrealistic rooms, wrong proportions, low detail,"
                    " smudged, watercolor, oil painting, photorealistic, color gradients, shadows, perspective, 3d"
                )

                # Tuned for maximum detail: increase inference steps and guidance
                floor_image = client.text_to_image(
                    prompt=floor_prompt,
                    negative_prompt=negative_prompt,
                    model="stabilityai/stable-diffusion-xl-base-1.0",
                    height=1024,
                    width=1024,
                    num_inference_steps=80,
                    guidance_scale=9.0
                )
                floor_variations["variations"].append({
                    "variation": variation_num,
                    "image": floor_image.convert("RGBA")
                })

            floor_images.append(floor_variations)
        
        # Load fonts with multiple fallback options - bold fonts for better readability
        font_xlarge = None
        font_large = None
        font_medium = None
        font_small = None
        
        font_paths_bold = [
            "/System/Library/Fonts/Arial Bold.ttf",  # macOS Bold
            "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",  # Linux Bold
            "C:\\Windows\\Fonts\\arialbd.ttf",  # Windows Bold
        ]
        
        font_paths_regular = [
            "/System/Library/Fonts/Arial.ttf",  # macOS
            "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",  # Linux
            "C:\\Windows\\Fonts\\arial.ttf",  # Windows
            "arial.ttf"  # Relative path fallback
        ]
        
        # Try to load bold fonts first
        for font_path in font_paths_bold:
            try:
                font_xlarge = ImageFont.truetype(font_path, 32)
                font_large = ImageFont.truetype(font_path, 26)
                font_medium = ImageFont.truetype(font_path, 20)
                font_small = ImageFont.truetype(font_path, 16)
                break
            except:
                continue
        
        # Fallback to regular fonts if bold not found
        if font_xlarge is None:
            for font_path in font_paths_regular:
                try:
                    font_xlarge = ImageFont.truetype(font_path, 32)
                    font_large = ImageFont.truetype(font_path, 26)
                    font_medium = ImageFont.truetype(font_path, 20)
                    font_small = ImageFont.truetype(font_path, 16)
                    break
                except:
                    continue
        
        # Fallback to default if no truetype font found
        if font_xlarge is None:
            font_xlarge = ImageFont.load_default()
            font_large = ImageFont.load_default()
            font_medium = ImageFont.load_default()
            font_small = ImageFont.load_default()
        
        # Overlay drawing removed: backend will not draw text labels, markers, or legends.
        # Room labels and annotations should be generated by the AI model itself.
        
        # Legend and overlay composition removed: backend will not compose legends or draw annotations.
        # Images returned from the model will be used directly as final blueprints.
        
        # Select the sharpest variation for each floor and prepare labeled images
        labeled_floor_images = []
        for floor_item in floor_images:
            floor_num = floor_item["floor"]
            variations = floor_item["variations"]

            best_score = -1
            best_variation_num = None
            best_variation_image = None

            for variation_item in variations:
                variation_num = variation_item["variation"]
                variation_image = variation_item["image"]
                try:
                    score = compute_sharpness(variation_image)
                except Exception:
                    score = 0

                if score > best_score:
                    best_score = score
                    best_variation_num = variation_num
                    best_variation_image = variation_image

            # Fallback if no variation selected
            if best_variation_image is None and variations:
                best_variation_image = variations[0]["image"]
                best_variation_num = variations[0]["variation"]

            # Use the raw best variation produced by the model (no overlays)
            labeled_img = best_variation_image
            labeled_floor_images.append({
                "floor": floor_num,
                "image": labeled_img,
                "best_variation": best_variation_num,
                "sharpness_score": best_score
            })
        
        # Save individual floor images with new naming convention
        png_paths = []
        for floor_item in labeled_floor_images:
            floor_path = f"generated_plan_floor_{floor_item['floor']}.png"
            try:
                floor_item["image"].save(floor_path)
                png_paths.append(floor_path)
            except Exception as save_error:
                return jsonify({
                    "success": False,
                    "error": f"Failed to save floor {floor_item['floor']} blueprint: {str(save_error)}"
                }), 500
        
        # Generate PDF with all floors if multiple floors exist
        pdf_path = None
        if num_floors > 1:
            try:
                # Convert RGBA images to RGB for PDF compatibility
                rgb_images = []
                for floor_item in labeled_floor_images:
                    try:
                        # Create white background for RGBA to RGB conversion
                        rgb_image = Image.new("RGB", floor_item["image"].size, "white")
                        rgb_image.paste(floor_item["image"], mask=floor_item["image"].split()[3])
                        rgb_images.append(rgb_image)
                    except Exception as convert_error:
                        print(f"Warning: Failed to convert floor {floor_item['floor']} to RGB: {convert_error}")
                        continue
                
                # Save all images as a single PDF
                if rgb_images:
                    pdf_path = "all_floors.pdf"
                    try:
                        rgb_images[0].save(
                            pdf_path,
                            save_all=True,
                            append_images=rgb_images[1:] if len(rgb_images) > 1 else [],
                            duration=100,
                            loop=0
                        )
                        print(f"PDF generated successfully: {pdf_path}")
                    except Exception as pdf_save_error:
                        print(f"Warning: Failed to save PDF: {pdf_save_error}")
                        pdf_path = None
            except Exception as pdf_error:
                # If PDF generation fails, log it but continue
                print(f"PDF generation warning: {pdf_error}")
                pdf_path = None
        
        # Save combined multi-floor document (PNG only)
        multi_floor_png_path = None
        try:
            # Calculate dynamic dimensions based on actual image sizes
            if labeled_floor_images:
                first_floor_width, first_floor_height = labeled_floor_images[0]["image"].size
                separator_height = 40
                total_height = sum(img["image"].size[1] + separator_height for img in labeled_floor_images)
                
                # Create canvas with width of first floor image (all should be same width now with legend)
                multi_floor_image = Image.new("RGBA", (first_floor_width, total_height), "white")
                
                current_y = 0
                separator_draw = ImageDraw.Draw(multi_floor_image)
                
                for floor_item in labeled_floor_images:
                    floor_img = floor_item["image"]
                    floor_width, floor_height = floor_img.size
                    
                    # Paste floor image
                    multi_floor_image.paste(floor_img, (0, current_y))
                    current_y += floor_height
                    
                    # Add separator line between floors
                    if floor_item["floor"] < num_floors:
                        separator_draw.line(
                            [(0, current_y), (floor_width, current_y)],
                            fill="black",
                            width=3
                        )
                        # Add "Next Floor" text on separator
                        try:
                            separator_draw.text(
                                (floor_width // 2 - 50, current_y + 10),
                                f"--- Floor {floor_item['floor'] + 1} ---",
                                fill="black",
                                font=font_large
                            )
                        except:
                            pass
                        current_y += separator_height
            
            # Save combined multi-floor document (PNG format)
            multi_floor_png_path = "blueprint_combined_all_floors.png"
            multi_floor_image.save(multi_floor_png_path)
        except Exception as save_error:
            return jsonify({
                "success": False,
                "error": f"Failed to save combined multi-floor blueprint: {str(save_error)}"
            }), 500

        # Return the combined multi-floor blueprint (or PDF if multiple floors)
        try:
            if pdf_path and num_floors > 1:
                # Return PDF if successfully created
                return send_file(pdf_path, mimetype="application/pdf", as_attachment=True, download_name="all_floors.pdf")
            else:
                # Return PNG if single floor or PDF generation failed
                if multi_floor_png_path:
                    return send_file(multi_floor_png_path, mimetype="image/png")
                else:
                    return jsonify({
                        "success": False,
                        "error": "No output file was generated"
                    }), 500
        except Exception as send_error:
            return jsonify({
                "success": False,
                "error": f"Failed to send generated blueprint file: {str(send_error)}"
            }), 500

    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500

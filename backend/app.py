from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/api/recommendations', methods=['POST'])
def get_recommendations():
    """
    Expects a POST request with JSON data containing soil metrics.
    Example Input JSON:
    {
        "soil_type": "Clay",
        "ph_level": 6.0,
        "moisture": 40,
        "nitrogen": 15,
        "weather_condition": "Rainy"
    }
    """
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({"error": "No input data provided"}), 400

        # Extract values (with defaults if missing)
        ph_level = data.get('ph_level', 7.0)
        nitrogen = data.get('nitrogen', 50)
        moisture = data.get('moisture', 50)

        recommendations = []

        # -- Recommendation Logic (Engineering/Agriculture Rules) --

        # 1. pH Level Logic
        if ph_level < 6.0:
            recommendations.append({
                "material": "Agricultural Lime",
                "reason": f"Soil pH is low ({ph_level}). Lime will help neutralize acidity and improve nutrient availability.",
                "priority": "High"
            })
        elif ph_level > 7.5:
             recommendations.append({
                "material": "Elemental Sulfur or Peat Moss",
                "reason": f"Soil pH is high ({ph_level}). Acidifying materials will help lower it.",
                "priority": "High"
            })

        # 2. Nitrogen Logic
        if nitrogen < 30:
             recommendations.append({
                "material": "High-Nitrogen Fertilizer (e.g., Urea or Blood Meal)",
                "reason": f"Nitrogen level is very low ({nitrogen}). Essential for leafy growth.",
                "priority": "High"
            })
        elif nitrogen < 50:
             recommendations.append({
                "material": "Balanced NPK Fertilizer",
                "reason": f"Nitrogen is slightly low ({nitrogen}). A balanced mix will support steady growth.",
                "priority": "Medium"
            })

        # 3. Moisture Logic
        if moisture < 30:
             recommendations.append({
                "material": "Organic Compost / Mulch",
                "reason": f"Moisture retention is poor ({moisture}%). Compost will improve water holding capacity.",
                "priority": "Medium"
            })
        elif moisture > 80:
             recommendations.append({
                "material": "Sand or Perlite Amendment",
                "reason": f"Soil is waterlogged ({moisture}%). Needs improved drainage materials.",
                "priority": "Medium"
            })

        # Default fallback if soil is perfect
        if not recommendations:
            recommendations.append({
                "material": "General Purpose Compost",
                "reason": "Soil conditions look good! General compost will maintain soil health.",
                "priority": "Low"
            })

        return jsonify({
            "status": "success",
            "received_data": data,
            "recommendations": recommendations
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)

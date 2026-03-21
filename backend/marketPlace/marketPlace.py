from flask import Flask, request, jsonify
from flask_cors import CORS
import stripe
import os
from dotenv import load_dotenv
import json
from datetime import datetime


load_dotenv(dotenv_path=".env")

app = Flask(__name__)
CORS(app)

# Get base URL from environment (for production)
BASE_URL = os.getenv('BASE_URL', 'http://127.0.0.1:5001')

# Your Real Key
stripe.api_key = os.getenv("STRIPE_SECRET_KEY")

if not stripe.api_key:
    raise ValueError("Stripe API key not found. Check your .env file.")

# Fixed Warning Logic
if stripe.api_key.startswith("sk_test_51"):
    print("WARNING: You are using a placeholder Stripe API key.")



@app.route('/create-checkout', methods=['POST'])
def create_checkout():
    try:
        session = stripe.checkout.Session.create(
            payment_method_types=['card'],
            line_items=[{
                'price_data': {
                    'currency': 'usd',
                    'product_data': {
                        'name': 'ArchiSri GS Pro',
                        'description': 'IoT Soil Moisture & Saltiness Sensor',
                    },
                    'unit_amount': 1443, 
                },
                'quantity': 1,
            }],
            mode='payment',
            success_url=f'{BASE_URL}/success',
            cancel_url=f'{BASE_URL}/cancel',
        )
        return jsonify({'url': session.url})
    except Exception as e:
        print(f"Error: {e}") # This prints the error in your terminal
        return jsonify(error=str(e)), 500

@app.route('/success')
def success():
    return " Payment Successful!"

@app.route('/cancel')
def cancel():
    return " Payment Cancelled!"


if __name__ == '__main__':
    port = int(os.getenv('PORT', 5001))
    debug = os.getenv('FLASK_ENV', 'production') == 'development'
    app.run(debug=debug, host='0.0.0.0', port=port)
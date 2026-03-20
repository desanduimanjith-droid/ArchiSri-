# Blueprint Generator Backend

Flask API service that generates AI architectural blueprint images using OpenAI image generation.

## Endpoints

- `GET /` health/status
- `POST /blueprint` generate blueprint PNG from requirements

## Prerequisites

- Python 3.10+
- OpenAI API key

## Setup

```bash
cd backend/blueprint-generator
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Set API key once in your shell profile (recommended):

```bash
echo 'export OPENAI_API_KEY="YOUR_NEW_KEY"' >> ~/.zshrc
source ~/.zshrc
```

Alternative supported variable:

- `BLUEPRINT_OPENAI_API_KEY`

## Run

```bash
cd backend/blueprint-generator
source .venv/bin/activate
python app.py
```

Service runs at: `http://127.0.0.1:5002`

## Generate Blueprint (example)

```bash
curl -X POST http://127.0.0.1:5002/blueprint \
  -H "Content-Type: application/json" \
  -d '{
    "landsize": 3500,
    "floors": 2,
    "style": "Modern",
    "bedrooms": 4,
    "bathrooms": 3,
    "kitchen": 1,
    "living_room": 1
  }' \
  --output architectural_blueprint.png
```
## Technical Flow
1. Receives architectural requirements via POST request.
2. Constructs a specialized prompt for OpenAI DALL-E.
3. Generates a high-resolution blueprint image.
4. Returns the result to the ArchiSri frontend interface.

## Error Handling
- Validates landsize and room counts before API calls.
- Handles OpenAI API quota or connectivity errors.

## Future Enhancements
- Integration with GPT-4o for more detailed architectural descriptions.
- Support for multiple blueprint styles (Minimalist, Traditional, Industrial).
- Caching generated images to reduce OpenAI API costs and latency.
- Direct export to PDF format for architectural documentation.

## Notes

- Do **not** hardcode API keys in source files.
- If key is missing, API returns a clear JSON error.
- Keep your key private and rotate immediately if exposed.

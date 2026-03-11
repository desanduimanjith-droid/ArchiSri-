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

## Notes

- Do **not** hardcode API keys in source files.
- If key is missing, API returns a clear JSON error.
- Keep your key private and rotate immediately if exposed.

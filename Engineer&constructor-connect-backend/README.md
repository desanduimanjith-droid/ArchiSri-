# Constructor Connect Backend API

Flask REST API backend for the Constructor Connect app.

## Current Project Structure

```text
.
├── app.py
├── database.py
├── models.py
├── routes/
│   ├── constructors.py
│   ├── engineers.py
│   └── requests.py
├── requirements.txt
└── run_backend.sh
```

## Features

- Constructors CRUD + filtering
- Engineers CRUD + filtering
- Customer request flow (create, list, update status, delete)
- SQLite with SQLAlchemy
- CORS enabled for frontend integration
- Seed data on first run

## Setup

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python app.py
```

Server runs on `http://localhost:8000`.

## API Endpoints

### Constructors
- `GET /api/constructors`
- `GET /api/constructors/<id>`
- `POST /api/constructors`
- `PUT /api/constructors/<id>`
- `DELETE /api/constructors/<id>`

### Engineers
- `GET /api/engineers`
- `GET /api/engineers/<id>`
- `POST /api/engineers`
- `PUT /api/engineers/<id>`
- `DELETE /api/engineers/<id>`

### Requests
- `POST /api/requests`
- `GET /api/requests/<user_id>`
- `GET /api/requests/<request_id>`
- `PUT /api/requests/<request_id>`
- `DELETE /api/requests/<request_id>`
- `GET /api/constructor/<constructor_id>/requests`

### Health
- `GET /api/health`

## Notes

- Main DB used by the app is `constructor_connect.db`.
- Seed data is inserted only when constructors table is empty.

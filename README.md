# README

## 🎮 Game Tracking API

Simple JSON API to track game playthroughs and player progress.

## Installation

```bash
    bundle install
    rails db:create db:migrate db:seed
```

## Usage

### Start the server

```bash
    rails server
```

## 🔧 API Endpoints

All endpoints are versioned under `/api/v1`

### Create a Player

**POST** `/api/v1/players`

Creates a new player with a given name.

**Request body:**

```json
{
  "player": {
    "name": "Jaskier"
  }
}
```

**Example CURL:**

```bash
    curl -X POST http://localhost:3000/api/v1/players \
        -H "Content-Type: application/json" \
        -d '{"player": {"name": "Jaskier"}}'
```

**Response:**

```json
    {
        "id": "f3248d3a-14ad-4758-a781-f8ebcec95363",
        "name": "Jaskier",
        "created_at": "2025-05-12T10:00:00Z",
        "updated_at": "2025-05-12T10:00:00Z"
    }
```

### Create a Playthrough for a Player

**POST** `/api/v1/players/:player_id/playthroughs`

Creates a new playthrough associated with a specific player.

**Request body:**

```json
    {
        "playthrough": {
            "started_at": "2025-05-12T10:00:00Z",
            "finished_at": "2025-05-12T11:00:00Z",
            "score": 1250.75,
            "time_spent": 3600.0
        }
    }
```

**Example CURL:**

```bash
    curl -X POST http://localhost:3000/api/v1/players/{player_id}/playthroughs \
        -H "Content-Type: application/json" \
        -d '{
            "playthrough": {
            "started_at": "2025-05-12T10:00:00Z",
            "finished_at": "2025-05-12T11:00:00Z",
            "score": 1250.75,
            "time_spent": 3600.0
            }
        }'
```

**Response:**

```json
    {
        "id": "a1234567-b89c-012d-345e-67890fghijkl",
        "player_id": "f3248d3a-14ad-4758-a781-f8ebcec95363",
        "started_at": "2025-05-12T10:00:00Z",
        "finished_at": "2025-05-12T11:00:00Z",
        "score": 1250.75,
        "time_spent": 3600.0,
        "created_at": "2025-05-12T11:00:05Z",
        "updated_at": "2025-05-12T11:00:05Z"
    }
```

### List Playthroughs for a Player

**GET** `/api/v1/players/:player_id/playthroughs`

Retrieves all playthroughs for a given player.

**Example CURL:**

```bash
    curl http://localhost:3000/api/v1/players/{player_id}/playthroughs
```

**Response:**

```json
    [
        {
            "id": "a1234567-b89c-012d-345e-67890fghijkl",
            "player_id": "f3248d3a-14ad-4758-a781-f8ebcec95363",
            "started_at": "2025-05-12T10:00:00Z",
            "finished_at": "2025-05-12T11:00:00Z",
            "score": 1250.75,
            "time_spent": 3600.0,
            "created_at": "2025-05-12T11:00:05Z",
            "updated_at": "2025-05-12T11:00:05Z"
        }
    ]
```

## Testing

Run tests with:

```bash
    bundle exec rspec
```

## Linter

Run RuboCop with:

```bash
    rubocop
```

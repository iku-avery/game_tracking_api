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
        "name": "Jaskier"
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
            "score": 1250.75,
            "time_spent": 3600.0,
            "created_at": "2025-05-12T11:00:05Z",
            "updated_at": "2025-05-12T11:00:05Z"
        }
    ]
```

### Weekly Summary

Retrieve a summary of players’ weekly playthrough statistics, with optional date filtering and sorting.

**GET** `/api/v1/weekly_summary`

Returns a summary of players’ playthroughs for a specified week or the current week by default.

#### Request Parameters

| Parameter   | Type   | Description                                                 | Default       |
| ----------- | ------ | ----------------------------------------------------------- | ------------- |
| `date`      | string | The date to fetch the week containing this date (ISO 8601). | Current date  |
| `sort_by`   | string | Field to sort by: `total_score` or `total_duration`.        | `total_score` |
| `direction` | string | Sort direction: `asc` or `desc`.                            | `desc`        |

Weekly Summary with `date`, sort by `total_score` or `total_duration`

**GET** `api/v1/weekly_summary?date={date}&sort_by={field}&direction={direction}`

**Example CURL:**

```bash
    curl "http://localhost:3000/api/v1/weekly_summary?date=2025-05-12&sort_by=total_duration&direction=asc"
```

**Response:**

```json
    {
    "week_start_date": "2025-05-12",
    "week_end_date": "2025-05-18",
    "player_summaries": [
        {
        "player_id": "8c561c6a-6304-4952-9492-2ae6759ac0f5",
        "player_name": "Yennefer)",
        "total_score": 400.0,
        "total_duration": 3400.0
        },
        {
        "player_id": "2fd17a3d-ce8f-40e7-8730-1128f55b79ef",
        "player_name": "Ciri",
        "total_score": 500.0,
        "total_duration": 5000.0
        }
    ]
    }
```

### Get Impact Report

**GET** `/api/v1/impact_report`

Returns a list of all players with their impact score — defined as the difference between the first recorded score and the best recorded score in their history, sorted in descending order by highest impact.

**Example CURL:**

```bash
    curl http://localhost:3000/api/v1/impact_report
```

**Response:**

```json
    [
    {
        "player_id": "04cd7c11-1adf-4928-a08e-3f3165fb2e03",
        "player_name": "Consistent Improver",
        "first_score": 100.0,
        "best_score": 300.0,
        "impact": 200.0
    }]
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

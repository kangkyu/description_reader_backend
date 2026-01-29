# Description Reader Backend

Rails API backend and landing page for the [YouTube Description Reader](https://chromewebstore.google.com/detail/youtube-description-reade/bkhdnoojcjfgpkidgklhdaaimjjppeik) Chrome extension. The extension extracts Amazon product links from YouTube video descriptions and saves them for later.

## Requirements

- Ruby 3.4.8
- PostgreSQL
- Rails 8.1

## Setup

```sh
bin/setup
bin/rails db:create db:migrate
```

## Running

```sh
bin/rails server
```

## Tests

```sh
bin/rails test
```

Run a single test file or specific test by line number:

```sh
bin/rails test test/models/video_test.rb
bin/rails test test/models/video_test.rb:10
```

## Linting & Security

```sh
bin/rubocop
bin/brakeman
```

## Architecture

This is a Rails 8.1 API backend deployed on Heroku. It serves both a JSON API (consumed by the Chrome extension) and minimal web UI pages (landing page, privacy policy, saved videos).

### Controllers

- `ApplicationController` (inherits `ActionController::Base`) — web UI with full Rails features
- `Api::ApplicationController` (inherits `ActionController::API`) — JSON API endpoints
- Both use the `Authentication` concern for token-based auth via Bearer tokens

### Models

- `User` / `Session` — authentication and session management
- `Video` — YouTube videos identified by `youtube_id`
- `Summary` — user-generated summaries of videos, scoped to user
- `AmazonLink` — product links extracted from video descriptions; resolves `amzn.to` short URLs on save
- `VideoAmazonLink` — join table connecting videos to Amazon links

### API Endpoints

| Method | Path             | Description                  |
|--------|------------------|------------------------------|
| POST   | `/session`       | Login                        |
| DELETE | `/session`       | Logout                       |
| POST   | `/registration`  | Register a new account       |
| GET    | `/summaries`     | List saved summaries         |
| POST   | `/summaries`     | Save a video with links      |
| GET    | `/amazon_links`  | List saved Amazon links      |

### Web Pages

| Path       | Description              |
|------------|--------------------------|
| `/`        | Landing page             |
| `/privacy` | Privacy policy           |
| `/videos`  | Saved videos (auth required) |

## Chrome Extension

The companion Chrome extension source code lives in a separate repository. It communicates with this backend via the JSON API using Bearer token authentication.

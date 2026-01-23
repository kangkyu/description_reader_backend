# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Test Commands

- **Run all tests:** `bin/rails test`
- **Run a single test file:** `bin/rails test test/models/video_test.rb`
- **Run a specific test:** `bin/rails test test/models/video_test.rb:10` (line number)
- **Start development server:** `bin/rails server`
- **Database setup:** `bin/rails db:create db:migrate`
- **Lint:** `bin/rubocop` (uses rubocop-rails-omakase)
- **Security scan:** `bin/brakeman`

## Architecture

This is a Rails 8.1 API backend deployed on Heroku. It serves both a JSON API (for a separate frontend client) and minimal web UI pages.

### Dual Controller Structure

- `ApplicationController` (inherits `ActionController::Base`) - for web UI with full Rails features
- `Api::ApplicationController` (inherits `ActionController::API`) - for JSON API endpoints
- Both include the `Authentication` concern for token-based auth

### API Authentication

Token-based authentication via Bearer tokens in the Authorization header. Sessions are stored in the database (`Session` model) and linked to users. The `Authentication` concern handles session lookup via `find_session_by_token`.

### Core Domain Models

- `Video` - YouTube videos identified by `youtube_id`
- `Summary` - User-generated summaries of videos, scoped to user
- `AmazonLink` - Product links extracted from video descriptions; automatically resolves amzn.to short URLs on save
- `VideoAmazonLink` - Join table connecting videos to amazon links (many-to-many)

### Routes

API routes use `scope module: :api` to namespace controllers without URL prefix. Web routes are at root level.

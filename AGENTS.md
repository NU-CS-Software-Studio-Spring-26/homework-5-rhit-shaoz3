# AGENTS.md

## Stack
Rails 8.x activity finder app; verify exact patch version in `Gemfile.lock` before dependency edits.
PostgreSQL is used for development/test/production; Heroku production uses `DATABASE_URL`.
Views are ERB with Rails helpers/assets; Active Storage handles activity images, with S3 expected in production.
Tests use Rails built-in Minitest/controller tests. Background jobs should stay `inline` unless Solid Queue is fully installed and migrated.

## Commands
Setup: `bundle install && bin/rails db:setup`
Run locally: `bin/rails server`
Test: `bin/rails test`
Lint: `bin/rubocop`
Deploy DB tasks on Heroku: `heroku run rails db:migrate` and, only when needed, `heroku run rails db:seed`.

## Conventions
Activity fields use `title`, `description`, `location`, `city`, `category`, and `event_date`; do not rename `title` to `name`.
Authentication/authorization lives in controllers/helpers using `current_user`; users may only edit their own account and activities.
Controllers should use one clear save/update path, then redirect or render with `status: :unprocessable_entity` on validation failure.
Shared reusable ERB belongs in `app/views/shared/` partials; activity-specific partials belong in `app/views/activities/`.
Activity images are attached with Active Storage, capped at 10, and the first ordered image acts as the thumbnail.

## Don'ts
Do not add new gems or JavaScript frameworks without approval.
Do not commit real API keys, AWS credentials, Google Maps keys, `.env` files, or production secrets.
Do not use local disk storage for production image uploads; production images should use S3.
Do not add `skip_before_action :verify_authenticity_token` to bypass Rails protections.
Do not seed real user data; use only safe sample data in `db/seeds.rb`.
Do not enable Solid Queue in production unless its tables/config are installed and migrations have run successfully.

# Teddy

Abotkit crawler. When setting up a new bot, you often find yourself extracting
information from a website (FAQs, menus, product pages, ...). This app is a
standalone website that aims to store which elements to extract in a database
which the user can edit. The crawlers will run in the same process as the
webapp.

## Features

- [x] Create new websites
- [x] Define elements to extract (using CSS-selectors)
- [x] Preview and downlad the resulting crawl
- [x] Easy deployment to e.g. Heroku
- [x] Export to S3
- [ ] Crawl multiple elements per site (for example from menus or listings)

## Roadmap

The goal would be to have a small CRM where you can setup your websites and
crawlers, run them periodically and use Python scripts or similar to generate
the basic bot configurations that you can deploy then. See the other Abotkit
repositories for that functionality.

## Starting the server locally

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

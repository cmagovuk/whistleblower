# CMA Whistleblower Web Application

## Development Environment

Development was carried out in a Hyper-V virtual machine built via the Quick Create Action, Ubuntu 20.04 Operating System.

## Prerequisites

- Ruby 2.7.4
- PostgreSQL
- NodeJs 14.x
- Yarn 1.22.x
- Docker

## Setting up the app in development

1. Run `bundle install` to install the gem dependencies
2. Run `yarn` to install node dependencies
3. Run `bin/rails db:setup` to set up the database development and test schemas, and seed with test data
4. Run `bundle exec rails server` to launch the app on http://localhost:3000
5. Run `./bin/webpack-dev-server` in a separate shell for faster compilation of assets

## Frameworks used

- The development is based on the [DFE Rails Template](https://github.com/DFE-DDigital/rails-template), which includes the GOV UK Design System Form Builder

## Environment variables

The application requires the following environment variables to be configured

| Name | Purpose |
| --- | --- |
| DB_HOST | Database URL
| DB_DATABASE | Database name
| DB_USERNAME | Database username
| DB_PASSWORD | Database password
| STORAGE_ACCOUNT_NAME | Azure Storage account name
| STORAGE_ACCESS_KEY | Azure Storage access key
| STORAGE_CONTAINER | Azure Storage container name
| GOVUK_NOTIFY_API_KEY | GOV UK Notification Service API Key
| SERVICE_REVIEW_URL | URL of feedback form
| MWR_TRANSMIT_API | URL of service API

## Licence

[MIT License](LICENCE)

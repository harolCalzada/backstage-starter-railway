# Backstage on Railway

This is a template for deploying a [Backstage](https://backstage.io) IDP instance on Railway.

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template?template=https://github.com/vipulasri/backstage-railway&plugins=postgresql)

## Features

- **Multi-stage Dockerfile**: Efficient build process for Railway.
- **PostgreSQL Support**: Configured to work with Railway's Postgres plugin (`PG*` variables).
- **Dynamic Port**: Binds to Railway's `$PORT`.

## Prerequisites

- A Railway account.
- A GitHub repository (if deploying via Git).

## Environment Variables

The following environment variables are required:

| Variable | Description | Example |
| :--- | :--- | :--- |
| `APP_BASE_URL` | The public URL of your application. | `https://backstage-production.up.railway.app` |
| `PGHOST` | Postgres Host (Provided by Railway Postgres service) | |
| `PGPORT` | Postgres Port (Provided by Railway Postgres service) | |
| `PGUSER` | Postgres User (Provided by Railway Postgres service) | |
| `PGPASSWORD` | Postgres Password (Provided by Railway Postgres service) | |

*Note: The `PG*` variables are automatically provided if you add a PostgreSQL service to your project.*

## Deployment

1.  **Use the Template**: Click the button below (once you have the template link) or deploy this repo.
2.  **Add a Database**: In your Railway project, add a **PostgreSQL** service.
3.  **Link Variables**: Ensure the `PG*` variables from the Postgres service are available to the Backstage service (Railway usually handles this if they are in the same project).
4.  **Set `APP_BASE_URL`**: After your first deployment (which might fail or wait), get the public domain from Railway settings and set the `APP_BASE_URL` variable. Redeploy.

## Local Development

1.  `yarn install`
2.  `yarn dev`

## License

Apache-2.0

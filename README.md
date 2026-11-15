# Portfolio Dashboard

Vanilla JS single-page dashboard — PKCE login, orders list, and live metrics charts.
Served via nginx.

## Prerequisites

- Docker Desktop
- `portfolio-service` stack running (API on port 8080, Auth on port 5001)

## Running locally

```bash
docker compose up --build
```

Open: http://localhost:3000  
Login: `demo` / `demo123`

## Stack

- Static HTML/JS (no build step)
- nginx:alpine container
- PKCE OAuth2 flow against Duende IdentityServer (port 5001)
- Calls Orders API (port 8080) directly from the browser

## Start order

1. `setup.ps1` in `portfolio-service` → starts API + Auth + Sync
2. `docker compose up` here → starts dashboard on port 3000

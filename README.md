# DevOps Mini App

A deliberately small application for practicing DevOps tools.

## Architecture

Client -> FastAPI -> PostgreSQL

## Endpoints

- `GET /` - basic application response
- `GET /health` - health check
- `GET /db` - verifies the PostgreSQL connection

## Run with Docker Compose

```bash
docker compose up --build
```

Then open:

- http://localhost:8000/
- http://localhost:8000/health
- http://localhost:8000/db

Stop the application:

```bash
docker compose down
```

Remove containers and the database volume:

```bash
docker compose down -v
```

## DevOps exercises to add later

1. Add an Nginx reverse proxy.
2. Create AWS infrastructure with Terraform.
3. Configure the VM with Ansible.
4. Push the image to Docker Hub or Amazon ECR.
5. Add GitHub Actions for test/build/deploy.
6. Add monitoring or centralized logging.

# Grandstream Provisioning Server

Web server for provisioning configuration files for Grandstream phones.

## Features

- Nginx server with PHP for serving XML configuration files
- API key protected endpoint for uploading files
- Production-ready Docker container
- GitHub Actions for automated builds

## Docker Usage

### Environment Variables

- `UPLOAD_API_KEY`: API key to protect the file upload endpoint

### Run the Container

```bash
docker run -d \
  -p 8080:80 \
  -e UPLOAD_API_KEY=your_secret_key \
  -v $(pwd)/provision:/usr/share/nginx/html/provision \
  ghcr.io/aldoggutierrez/provision-server:latest
```

### Docker Compose

```bash
docker-compose up -d
```

## Endpoints

- `GET /provision/*.xml` - Provisioning files (public access for phones)
- `POST /upload` - Upload XML files (requires `X-API-Key` header)
- `GET /upload` - List available XML files (requires `X-API-Key` header)

## Upload Files

```bash
curl -X POST \
  -H "X-API-Key: your_secret_key" \
  -F "file=@config.xml" \
  http://localhost:8080/upload
```

## CI/CD

The project uses GitHub Actions to automatically build and publish the Docker image to GitHub Container Registry when pushing to the `main` branch.

The image is available at: `ghcr.io/your-username/provision-server:latest`

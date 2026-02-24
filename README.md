# Servidor de Provisión Grandstream

Servidor web para provisionamiento de archivos de configuración de teléfonos Grandstream.

## Características

- Servidor nginx con PHP para servir archivos de configuración XML
- Endpoint protegido con API key para subir archivos
- Contenedor Docker listo para producción
- GitHub Actions para build automático

## Uso con Docker

### Variables de entorno

- `UPLOAD_API_KEY`: Clave API para proteger el endpoint de subida de archivos

### Ejecutar el contenedor

```bash
docker run -d \
  -p 8080:80 \
  -e UPLOAD_API_KEY=tu_clave_secreta \
  -v $(pwd)/provision:/usr/share/nginx/html/provision \
  ghcr.io/tu-usuario/provision-server:latest
```

### Docker Compose

```bash
docker-compose up -d
```

## Endpoints

- `GET /provision/*.xml` - Archivos de provisión (acceso público para teléfonos)
- `POST /upload` - Subir archivos XML (requiere header `X-API-Key`)
- `GET /upload` - Listar archivos XML disponibles (requiere header `X-API-Key`)

## Subir archivos

```bash
curl -X POST \
  -H "X-API-Key: tu_clave_secreta" \
  -F "file=@config.xml" \
  http://localhost:8080/upload
```

## CI/CD

El proyecto usa GitHub Actions para construir y publicar automáticamente la imagen Docker a GitHub Container Registry cuando se hace push a la rama `main`.

La imagen está disponible en: `ghcr.io/tu-usuario/provision-server:latest`

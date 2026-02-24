FROM nginx:alpine

# Instalar PHP
RUN apk add --no-cache php83 php83-fpm php83-json

# Copiar configuración
COPY nginx.conf /etc/nginx/nginx.conf

# Crear directorio de provisión
RUN mkdir -p /usr/share/nginx/html/provision

# Script PHP simple para subir archivos
RUN cat > /usr/share/nginx/html/upload.php << 'EOF'
<?php
$uploadDir = '/usr/share/nginx/html/provision/';
$apiKey = getenv('UPLOAD_API_KEY');

$headers = getallheaders();
if (!isset($headers['X-API-Key']) || $headers['X-API-Key'] !== $apiKey) {
    http_response_code(401);
    echo json_encode(['error' => 'Unauthorized']);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_FILES['file'])) {
    $filename = basename($_FILES['file']['name']);
    
    if (!str_ends_with($filename, '.xml')) {
        http_response_code(400);
        echo json_encode(['error' => 'Only XML files allowed']);
        exit;
    }
    
    if (move_uploaded_file($_FILES['file']['tmp_name'], $uploadDir . $filename)) {
        echo json_encode(['success' => true, 'file' => $filename]);
    } else {
        http_response_code(500);
        echo json_encode(['error' => 'Upload failed']);
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $files = glob($uploadDir . '*.xml');
    $list = array_map('basename', $files);
    echo json_encode(['files' => $list]);
}
EOF

# Configurar PHP-FPM para escuchar en puerto 9000
RUN sed -i 's/listen = 127.0.0.1:9000/listen = 127.0.0.1:9000/' /etc/php83/php-fpm.d/www.conf || echo "listen = 127.0.0.1:9000" >> /etc/php83/php-fpm.d/www.conf

# Copiar script de inicio
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]

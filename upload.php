<?php
$uploadDir = '/usr/share/nginx/html/provision/';
$apiKey = getenv('UPLOAD_API_KEY');

$headers = getallheaders();
$normalizedHeaders = array_change_key_case($headers, CASE_LOWER);

if (!isset($normalizedHeaders['x-api-key']) || $normalizedHeaders['x-api-key'] !== $apiKey) {
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

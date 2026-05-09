<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");

include 'config/conexion.php';

$response = [];

// 🔥 CAMIONES
$camiones = [];
$result = $conn->query("SELECT id, tractor FROM unidades");
while ($row = $result->fetch_assoc()) {
    $camiones[] = $row;
}

// 🔥 CEDIS
$cedis = [];
$result = $conn->query("SELECT id, nombre FROM cedis");
while ($row = $result->fetch_assoc()) {
    $cedis[] = $row;
}

$response = [
    "success" => true,
    "camiones" => $camiones,
    "cedis" => $cedis,
];

echo json_encode($response);
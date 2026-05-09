<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");

include 'config/conexion.php';

$data = json_decode(file_get_contents("php://input"));

$cedis = $data->cedis ?? '';

$response = [];

if ($cedis) {

    $sql = "INSERT INTO cedis (nombre) VALUES (?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $cedis);

    if ($stmt->execute()) {
        $response = [
            "success" => true,
            "message" => "Cedis guardado correctamente"
        ];
    } else {
        $response = [
            "success" => false,
            "message" => "Error al guardar"
        ];
    }

} else {
    $response = [
        "success" => false,
        "message" => "Datos incompletos"
    ];
}

echo json_encode($response);
<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");

include 'config/conexion.php';

$data = json_decode(file_get_contents("php://input"));

$tractor   = $data->tractor ?? '';
$economico = $data->economico ?? '';
$placas    = $data->placas ?? '';
$modelo    = $data->modelo ?? '';
$capacidad    = $data->capacidad ?? '';

if ($tractor && $placas && $economico && $modelo && $capacidad) {

    $sql = "INSERT INTO unidades (tractor, economico, placas, modelo,capacidad)
            VALUES (?, ?, ?, ?,?)";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sssss", $tractor, $economico, $placas, $modelo,$capacidad);

    if ($stmt->execute()) {
        echo json_encode([
            "success" => true,
            "message" => "Camión guardado correctamente"
        ]);
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Error al guardar"
        ]);
    }

} else {
    echo json_encode([
        "success" => false,
        "message" => "Datos incompletos"
    ]);
}
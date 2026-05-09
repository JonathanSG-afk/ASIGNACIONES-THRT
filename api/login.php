<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");

include 'config/conexion.php';

$input = file_get_contents("php://input");
$data = json_decode($input);

$username = $data->user ?? '';
$password = $data->password ?? '';

$response = [];

if (!empty($username) && !empty($password)) {

    $sql = "SELECT 
                u.id,
                u.user,
                u.password,
                u.rol_id,
                dp.numero_empleado,
                dp.nombre,
                dp.apellido_paterno,
                dp.apellido_materno,
                dp.telefono,
                dp.email
            FROM usuarios AS u
            INNER JOIN datos_personales AS dp 
                ON dp.id = u.datos_id
            WHERE u.user = ?";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $username);
    $stmt->execute();

    $result = $stmt->get_result();

    if ($row = $result->fetch_assoc()) {

        if ($password == $row['password']) {

            $response = [
                "success" => true,
                "user" => [
                    "id" => $row['id'],
                    "username" => $row['user'],
                    "rol" => $row['rol_id'],
                    "numero_empleado" => $row['numero_empleado'],
                    "nombre" => $row['nombre'],
                    "apellido_paterno" => $row['apellido_paterno'],
                    "apellido_materno" => $row['apellido_materno'],
                    "telefono" => $row['telefono'],
                    "email" => $row['email']
                ]
            ];

        } else {
            $response = [
                "success" => false,
                "message" => "Contraseña incorrecta"
            ];
        }

    } else {
        $response = [
            "success" => false,
            "message" => "Usuario no encontrado"
        ];
    }

} else {
    $response = [
        "success" => false,
        "message" => "Datos incompletos"
    ];
}

echo json_encode($response);
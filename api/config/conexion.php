<?php

$host = "localhost";
$db_name = "THRT";
$username = "root";
$password = "";

$conn = new mysqli($host, $username, $password, $db_name);

if ($conn->connect_error) {
    die("Error de conexión: " . $conn->connect_error);
}
?>
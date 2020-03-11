<?php
    header('Access-Control-Allow-Origin: *');  
    header("Access-Control-Allow-Headers: *");
    header('Access-Control-Allow-Credentials: true');
    header('Access-Control-Allow-Methods: *');
    $connection  = mysqli_connect('localhost','root','','project_pet_health_monitoring');
	$collarId 	 = $_GET['collarId'];
    $temperature = $_GET['temperature'];

    $query      = "INSERT INTO logs (temperature, collar_id) VALUES ('$temperature', '$collarId')";
    $query_run  = mysqli_query($connection, $query);
    if($query_run){
        $response['success'] = true;
    }else{
        $response['success']    = false; 
    }
    echo json_encode($response);
    mysqli_close($connection);
?>
<?php
    header('Access-Control-Allow-Origin: *');  
    header("Access-Control-Allow-Headers: *");
    header('Access-Control-Allow-Credentials: true');
    header('Access-Control-Allow-Methods: *');
    $connection = mysqli_connect('localhost','root','','project_pet_health_monitoring');
	$collarId 	= $_GET['collarId'];
    $breed 	    = $_GET['breed'];
    $age        = $_GET['age'];

    $query		= "SELECT * FROM pets WHERE collar_id= '$collarId'";
    $query_run	= mysqli_query($connection, $query);

    if(mysqli_num_rows($query_run) > 0){
    	$response['success']	= false; 
    	$response['message']	= 'Pet with given collar id already exists';
    }else{
        $query      = "INSERT INTO pets (collar_id, breed, age) VALUES ('$collarId', '$breed', '$age')";
        $query_run  = mysqli_query($connection, $query);
        if($query_run){
            $response['success'] = true;
            $response['message'] = 'Saved successful';
        }else{
            $response['success'] = false; 
            $response['message'] = 'Error while saving';
        }
    }
    echo json_encode($response);
    mysqli_close($connection);
?>
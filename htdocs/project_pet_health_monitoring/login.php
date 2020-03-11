<?php
    header('Access-Control-Allow-Origin: *');  
    header("Access-Control-Allow-Headers: *");
    header('Access-Control-Allow-Credentials: true');
    header('Access-Control-Allow-Methods: *');
    $connection = mysqli_connect('localhost','root','','project_pet_health_monitoring');
	$username 	= $_GET['username'];
    $password 	= $_GET['password'];

    $query		= "SELECT * FROM admin WHERE username= '$username' AND password = '$password'";
    $query_run	= mysqli_query($connection, $query);

    if(mysqli_num_rows($query_run) > 0){
    	$response['success']	= true; 
    	$response['message']	= 'Login successful';
    }else{
    	$response['success']	= false; 
    	$response['message']	= 'Login failed';
    }
    echo json_encode($response);
    mysqli_close($connection);
?>
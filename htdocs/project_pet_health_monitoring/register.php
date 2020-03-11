<?php
    header('Access-Control-Allow-Origin: *');  
    header("Access-Control-Allow-Headers: *");
    header('Access-Control-Allow-Credentials: true');
    header('Access-Control-Allow-Methods: *');
    $connection = mysqli_connect('localhost','root','','project_pet_health_monitoring');
	$username 	= $_GET['username'];
    $email 	    = $_GET['email'];
    $mobile     = $_GET['mobile'];
    $password   = $_GET['password'];

    $query		= "SELECT * FROM admin WHERE username= '$username'";
    $query_run	= mysqli_query($connection, $query);

    if(mysqli_num_rows($query_run) > 0){
    	$response['success']	= false; 
    	$response['message']	= 'Account already exists';
    }else{
        $query      = "INSERT INTO admin (username, email, mobile, password) VALUES ('$username', '$email', '$mobile', '$password')";
        $query_run  = mysqli_query($connection, $query);
        if($query_run){
            $response['success'] = true;
            $response['message'] = 'Register successful';
        }else{
            $response['success']    = false; 
            $response['message']    = 'Error while creating account';
        }
    }
    echo json_encode($response);
    mysqli_close($connection);
?>
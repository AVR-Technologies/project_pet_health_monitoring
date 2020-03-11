<?php
    header('Access-Control-Allow-Origin: *');  
    header("Access-Control-Allow-Headers: *");
    header('Access-Control-Allow-Credentials: true');
    header('Access-Control-Allow-Methods: *');
    $connection = mysqli_connect('localhost','root','','project_pet_health_monitoring');
    $duration   = $_GET['duration'];
    $collarid   = $_GET['collarId'];

    $query      = "SELECT * FROM logs WHERE collar_id = '$collarid' AND uploaded_time BETWEEN ( NOW() - INTERVAL $duration DAY) AND NOW() ORDER BY uploaded_time ASC";

    // $query      = "SELECT * FROM logs WHERE uploaded_time BETWEEN ( NOW() - INTERVAL 12 DAY) AND NOW()";


    $query_run  = mysqli_query($connection, $query);
    $r          = array();

    if($query_run){
        if(mysqli_num_rows($query_run) > 0){
            while($row = mysqli_fetch_assoc($query_run)){
                $data['id']             = $row['id'];
                $data['temperature']    = $row['temperature'];
                $data['time']           = $row['uploaded_time'];
                $data['collarId']       = $row['collar_id'];
                $r[] = $data;
            }
            $response['success']    = true;
            $response['message']    = 'Data found';
            $response['data']       = $r;
        }else{
            $response['success']    = false;
            $response['message']    = 'Data is not available';
        }
    }
    else{
        $response['success']    = false;
        $response['message']    = 'Unknown error found';
    }
    echo json_encode($response);
    mysqli_close($connection);
?>
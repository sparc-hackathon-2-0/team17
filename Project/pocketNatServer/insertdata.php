<?php
//Created by Chris Thibault uder the GPL http://www.gnu.org/licenses/gpl-3.0.en.html
//Please enjoy the code and have fun!
header('Content-Type: text/json');
include_once("utils.php");
include_once("dBaseAccess.php");

$db = openDatabaseConnection(); //We need the database pointer, so always do this.

$params = secureParameters($_POST); //Secure params, then reassign to incoming array

if(!isset($params['lat']) || !isset($params['long']) || !isset($params['category'] || !isset($params['title'] || !isset($params['description']))
{
	$response['status'] = "failed";
	$response['message'] = "Invalid parameters provided. Please try again.";
	$response['sent_parameters'] = $params;
	
	echo json_encode($response);
	die;
}
/*
//This is the file upload and handeling code
$allowedExts = array("jpg", "jpeg", "gif", "png");
$extension = end(explode(".", $_FILES["file"]["name"]));
if ((($_FILES["file"]["type"] == "image/gif")
|| ($_FILES["file"]["type"] == "image/jpeg")
|| ($_FILES["file"]["type"] == "image/pjpeg"))
&& ($_FILES["file"]["size"] < 2000000)
&& in_array($extension, $allowedExts))
  {
  if ($_FILES["file"]["error"] > 0)
    {
    $response['status'] = "failed";
    $response['message'] = "Return Code: " . $_FILES["file"]["error"];
		
    echo json_encode($response);
    
    }
  else
    {
    //echo "Upload: " . $_FILES["file"]["name"] . "<br />";
    //echo "Type: " . $_FILES["file"]["type"] . "<br />";
    //echo "Size: " . ($_FILES["file"]["size"] / 1024) . " Kb<br />";
    //echo "Temp file: " . $_FILES["file"]["tmp_name"] . "<br />";

    while(1==1){
    $filekey = "file" . rand(1000, 9999) . time();
    if (file_exists("upload/" . $filekey))
      {
      
      }
    else
      {
      move_uploaded_file($_FILES["file"]["tmp_name"],
      "upload/" . $filekey);
      $fileurl = "http://184.73.178.89/upload/" . $filekey;
      break;
      }
      }
    }
  }
else
  {
  $response['status'] = "failed";
  $response['message'] = "Invalid file";
		
  echo json_encode($response);

]
  }
//end uplaod code
*/

$items = placeItem($params['lat'],$params['long'],$params['category'], $params['title'], $params['description'], $params['fileurl']); // List near items

if($items != NULL)
{
	$response['status'] = "success";
	$response['message'] = "";
	$response['results'] = $itmes;
	echo json_encode($response);
}
else
{
	$response['status'] = "failed";
	$response['message'] = "There was an error connecting to the database. Please try again.";
		
	echo json_encode($response);
}










?>
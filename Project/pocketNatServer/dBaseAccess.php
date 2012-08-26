<?php
//Created by Chris Thibault uder the GPL http://www.gnu.org/licenses/gpl-3.0.en.html
//Please enjoy the code and have fun!



/************************************************************************************************************
 openDatabaseConnection()
 This function opens the database connection for the session should be called at the beginning of each file 
 Returns: The handle for the SQL database, if needed
 ************************************************************************************************************/

function openDatabaseConnection() {
	
	$hostname = "hackathon.co37jabiv2ls.us-east-1.rds.amazonaws.com"; 
	
	$user = "admin";
	
	$pass = "binarystargate"; //I hate chris's dumb password
	
	$dbase = "hackathon_1";
	
	$connection = mysql_connect($hostname, $user , $pass) 
			or die (@"{\"status\":\"failed\",\"message\":\"Could not connect to database. Code 1:1. Please try again.\"");
	
	$db = mysql_select_db($dbase , $connection) 
			or die (@"{\"status\":\"failed\",\"message\":\"Could not connect to database. Code 1:2. Please try again.\"");

	
	mysql_set_charset("utf8", $connection);
	
	return $db;
}

/************************************************************************************************************
This function gets all the items near a passed location with the paramaters lat, long, category
 Returns: NULL for error, otherwise an array of the database contents for this user
 ************************************************************************************************************/

function getNearLocations($lat, $long, $category){
	
	$sql="SELECT * FROM locations";
	$result = mysql_query($sql);
	$count = mysql_num_rows($result);
	
	$finals = array();
	
	
	
	if($count>0){
		while ($row = mysql_fetch_assoc($result)) {
				//Return the array map
				array_push($finals,$row);
		}
		
		return $finals;
	}
	else {
		//No results returned
		return NULL;
	}
	
	//No rows for that access token found
	return NULL;
}

/************************************************************************************************************
 
 This function attempts to add a new item to the database.
 Returns: The SQL query result, check for failure using if($result === false)
 ************************************************************************************************************/

function placeItem($lat, $long, $category, $title, $desc, $fileurl)
{
	$time = time();
	$result = mysql_query("INSERT INTO locations (lat, long, title, description, pic_url, date, category) VALUES ($lat, $long, '$title', '$desc', '$fileurl', $time, '$category'");	
	return $result;
}





?>









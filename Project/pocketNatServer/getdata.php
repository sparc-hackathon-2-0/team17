<?php
//Created by Chris Thibault uder the GPL http://www.gnu.org/licenses/gpl-3.0.en.html
//Please enjoy the code and have fun!
header('Content-Type: text/json');
include_once("utils.php");
include_once("dBaseAccess.php");
include_once("getwikidata.php");



$db = openDatabaseConnection(); //We need the database pointer, so always do this.

$params = secureParameters($_POST); //Secure params, then reassign to incoming array
$params['lat'] = 32.900210;
$params['long'] = -79.916199;
$params['category'] = "test";
if(!isset($params['lat']) || !isset($params['long']) || !isset($params['category']))
{
	$response['status'] = "failed";
	$response['message'] = "Invalid parameters provided. Please try again.";
	$response['sent_parameters'] = $params;
	
	echo json_encode($response);
	die;
}

$items = getNearLocations($params['lat'],$params['long'],$params['category']); // List near items

if($items != NULL)
{
	$response['status'] = "success";
	$response['message'] = "";
	$wikiData = getWikiData($params['lat'], $params['long']);
	$mergedArray = array_merge($items, $wikiData);
	$response['items'] = $mergedArray;
	
	echo json_encode($response);
}
else
{
	$response['status'] = "failed";
	$response['message'] = "There was an error connecting to the database. Please try again.";
		
	echo json_encode($response);
}










?>
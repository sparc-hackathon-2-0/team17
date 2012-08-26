<?php



	
	
	function get_data($url)
	{
	
	
	//echo "hay";
	$ch = curl_init();
	$timeout = 5;
	curl_setopt($ch,CURLOPT_URL,$url);
	curl_setopt($ch,CURLOPT_RETURNTRANSFER,1);
	curl_setopt($ch,CURLOPT_CONNECTTIMEOUT,$timeout);
	curl_setopt($ch,CURLOPT_USERAGENT,'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.13) Gecko/20080311 Firefox/2.0.0.13');
	$data = curl_exec($ch);
	curl_close($ch);
	return $data;
	}
	
	function getWikiData($lat, $long){
	
	$url='http://api.wikilocation.org/articles?lat='.$lat.'&lng='.$long.'&limit=10&offset=0&format=json&locale=en&radius=20000'; //rss link for the twitter timeline
	//print_r(get_data($url)); //dumps the content, you can manipulate as you wish to
	 
	/* gets the data from a URL */
	
	$data = get_data($url);
	$json_a = json_decode($data, true);
	$articles = $json_a['articles'];
	
	$length = count($articles);
	
	$finalEndArray = array();

	
	
	for($i=0; $i<$length && $i<=10; $i++)
	{
		$currentDictionaryBeingBuilt = array();
		
		
		
		$title = $articles[$i]['title'];
		
		$currentDictionaryBeingBuilt['title'] = $title;
		$currentDictionaryBeingBuilt['id'] = 0;
		$currentDictionaryBeingBuilt['lat'] = $articles[$i]['lat'];
		$currentDictionaryBeingBuilt['long'] = $articles[$i]['lng'];
		$currentDictionaryBeingBuilt['date'] = 0;
		$currentDictionaryBeingBuilt['report'] = 0;
		$currentDictionaryBeingBuilt['data_source'] = "wiki";
		
		//http://en.wikipedia.org/w/api.php?action=query&prop=extracts&titles=Statue%20of%20Nelson%20Mandela,%20Parliament%20Square&format=json&exintro=1
		$url2='http://en.wikipedia.org/w/api.php?action=query&prop=extracts&titles=' . urlencode($title) . '&format=json&exintro=1';
		$data = get_data($url2);
		$json_a = json_decode($data, true);
		//var_dump($json_a);
		
		$query = $json_a['query'];
		$pages = $query['pages'];
		
		$items = array();
		
		foreach($pages as $currPage)
		{
			array_push($items, $currPage);
		}
		
		//Now you have a numerical list of items.
		
		$length2 = count($items);
		
		for($j=0; $j<$length2; $j++)
		{
			//echo $items[$j]['title']." : ".$items[$j]['extract']."<br>";
			$currentDictionaryBeingBuilt['description'] = $items[$j]['extract'];
			
			$imageList = "http://en.wikipedia.org/w/api.php?action=query&prop=extracts&titles=".urlencode($items[$j]['title'])."&format=json&prop=images";
			
			//echo $imageList;
			
			$data = get_data($imageList);
			$json_a = json_decode($data, true);
			
			
			$query = $json_a['query'];
			$pages = $query['pages'];
		
			$imagePage;
		
			foreach($pages as $currPage)
			{
				$imagePage = $currPage;

				break;
			}
			
			if(isset($imagePage))
			{
				//Now we can look for the image names
				$images = $imagePage['images'];
				
				$selectedImage;
				
				foreach($images as $currImage)
				{
				
					if(strpos(strtolower($currImage['title']),"commons-logo.svg") === false && strpos(strtolower($currImage['title']),".svg") === false && strpos(strtolower($currImage['title']),"icon") === false)
					{
						
						$selectedImage = str_replace("File:","",$currImage['title']);
						break;
					}
				}
				
				//We now have a selected image. Lets get the final URL.
				
				 $imageFileName = "http://en.wikipedia.org/w/api.php?action=query&titles=Image:".urlencode($selectedImage)."&prop=imageinfo&iiprop=url&format=json";
				 //echo "<br>";
				 //echo $imageFileName;
				 $data = get_data($imageFileName);
				 $json_a = json_decode($data, true);
				 
				 $query = $json_a['query'];
				 $pages = $query['pages'];
				 
				 $finalURL;
				 
				 foreach($pages as $currPage)
				 {
				 	//var_dump($currPage);
					 $imageInfo = $currPage['imageinfo'];
					 
					 $finalURL = $imageInfo[0]['url'];
					 $currentDictionaryBeingBuilt['pic_url'] = $finalURL;
					 break;
				 }
				 
				 
			}
		}
		
		array_push($finalEndArray, $currentDictionaryBeingBuilt);
	}
	
	//var_dump($articles);
	

	//var_dump($finalEndArray);	
	return $finalEndArray;

	}
	//echo getWikiData(32.900210,-79.916199);
?>
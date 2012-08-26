<?php
//Updated by Chris Thibault uder the GPL http://www.gnu.org/licenses/gpl-3.0.en.html
//Please enjoy the code and have fun!


date_default_timezone_set("America/Chicago");
	
$hostIP = $_SERVER['SERVER_ADDR'];
$publicHost = $hostIP;

//mb_language('uni');
//mb_internal_encoding("UTF-8");
//mb_http_output('UTF-8');
//ob_start('mb_output_handler');

// ===============================================================

function printArray($aArray)
{
	echo "<pre>";
	print_r($aArray);
	echo "</pre>";
}

// ===============================================================

function isDST(/* assumes "now" */)
{
	$result = false;
	if (date("T") == "CDT") $result = true;
	return $result;
}

// ===============================================================

function truncateSentence($sentence, $startIdx)
{
	// trim the sentence at the first space after specified position
	$sentenceLength = strlen($sentence);
	$spaceIdx = $startIdx;
	$continueLoop = true;
	$spaceFound = true;
	while ($continueLoop == true)
	{
		if ($spaceIdx >= $sentenceLength)
		{
			$continueLoop = false;
			$truncated = substr($sentence, 0, $sentenceLength);
		}
		if (substr($sentence, $spaceIdx, 1) == " ")
		{
			$continueLoop = false;
			$truncated = substr($sentence, 0, $spaceIdx) . "...";
		}
		if ($spaceIdx > ($startIdx + 16))
		{
			$continueLoop = false;
			$truncated = substr($sentence, 0, $startIdx) . "...";
		}
		$spaceIdx++;
	}
	return $truncated;
}

// ===============================================================

function trimElement($element)
{
	$result = strip_tags($element);
	$result = truncateSentence($result, 200);
	return $result;
}

// ===============================================================

function fixText($originalString)
{
	// equivalent ascii values of these characters.
	//`(96) ’(130) „(132) ‘(145) ’(146) “(147) ”(148) ´(180) 

/*
	$result = '';
	$s1 = iconv('UTF-8', 'ASCII//TRANSLIT', $originalString);

	$sourceEncoding = "ASCII";
	$t1 = iconv($sourceEncoding, 'utf-8', "`’„‘’´");
	$t2 = iconv($sourceEncoding, 'utf-8', "'','''");
	$t3 = iconv($sourceEncoding, 'utf-8', '“”');
	$t4 = iconv($sourceEncoding, 'utf-8', '""');

	for ($i = 0; $i < strlen($s1); $i++)
	{
		$ch1 = $s1[$i];
		$ch2 = mb_substr($s, $i, 1);
		$ch3 = $ch1=='?'?$ch2:$ch1;

		$ch3 = strtr($ch3, $t1, $t2);
		$ch3 = strtr($ch3, $t3, $t4); 
		
		$result .= $ch3;
	}
*/
	$result = $originalString;

	$t1 = "`’„‘’´";
	$t2 = "'','''";
	$t3 = '“”';
	$t4 = '""';

//	$result = strtr($result, $t1, $t2);
//	$result = strtr($result, $t3, $t4); 

	//$result = strtr($result, "\\", ""); 
	
	
	$result = str_replace("\n", " ", $result);
	$result = str_replace("\r", " ", $result);
	$result = str_replace("\t", " ", $result);
	$result = str_replace("\v", " ", $result);
	$result = str_replace("\f", " ", $result);
	$result = trim($result);
	
/*
	if ($originalString != $result)
	{
		echo "fixText changed line -<br>";
		echo $originalString . "<br>";
		echo $result . "<br>";
	}
*/

	return $result;
}

// ===============================================================

function addLeadingZeros($value, $positions)
{
	$result = $value;
	
	$valueLen = strlen($value);
	if ($valueLen < $positions)
	{
		$result = str_repeat("0", $positions - $valueLen) . $value;
	}
	
	return $result;
}

// ===============================================================

function secureParameters($aArray)
{
	$result = $aArray;
	$result = array_map("htmlspecialchars", $result);	# secure from XSS
	$result = array_map("trim", $result); # Remove leading/trailing spaces
	$result = array_map("stripslashes",$result);//Remove slashes
	$result = array_map("mysql_real_escape_string", $result); # SQL injections
	return $result;
}





?>
<?php

$mysqli = new mysqli('localhost', 'wwf', 'wwfciigar', 'wwf');
$session_key = "this key is super secret for ciigar";

if ($mysqli->connect_error) {
	echo "result=db";
	exit();
}

function isValidUser($id, $nonce) {
	
	global $mysqli;
	
	# TODO: Should IP address be checked here as well?
	$sql = "SELECT COUNT(id) FROM users WHERE id = ? AND nonce = ?";
	
	$stmt = $mysqli->prepare($sql);
	$stmt->bind_param("is", $id, $nonce); 
	
	$stmt->execute();
	$stmt->bind_result($c);
	
	$stmt->fetch();
	if ($c == 0) {
		echo "result=user_fail";		
		return false;
	}
	else {
		return true;
	}
	
	
}	

$action = isset($_REQUEST['action']) ? $_REQUEST['action'] : NULL;

if ($action == 'new') {

	$ip = $_SERVER['REMOTE_ADDR'];
	$uagent = $_SERVER['HTTP_USER_AGENT'];
	$nonce = sha1($session_key .  rand() . $ip);
	
	echo $uagent;
	
	# Adobe Flash Variables
	$avHardwareDisable = $_REQUEST['AVD'];
	$hasAccessibility	= $_REQUEST['ACC'];
	$hasAudio	= $_REQUEST['A'];
	$hasAudioEncoder = $_REQUEST['AE'];
	$hasEmbeddedVideo	= $_REQUEST['EV'];
	$hasIME	= $_REQUEST['IME'];
	$hasMP3	= $_REQUEST['MP3'];
	$hasPrinting = $_REQUEST['PR'];
	$hasScreenBroadcast =	$_REQUEST['SB'];
	$hasScreenPlayback = $_REQUEST['SP'];
	$hasStreamingAudio = $_REQUEST['SA'];
	$hasStreamingVideo = $_REQUEST['SV'];
	$hasTLS	= $_REQUEST['TLS'];
	$hasVideoEncoder = $_REQUEST['VE'];
	$isDebugger	= $_REQUEST['DEB'];
	$language	= $_REQUEST['L'];
	$localFileReadDisable =	$_REQUEST['LFD'];
	$manufacturer	= $_REQUEST['M'];
	$maxLevelIDC = $_REQUEST['ML'];
	$os = $_REQUEST['OS'];
	$pixelAspectRatio = $_REQUEST['AR'];
	$playerType = $_REQUEST['PT'];
	$screenColor = $_REQUEST['COL'];
	$screenDPI = $_REQUEST['DP'];
	$screenResolutionX = $_REQUEST['R'];
	$screenResolutionY = $_REQUEST['R'];
	$version = $_REQUEST['V'];		
	$windowlessMode = $_REQUEST['WD'];
		
	
	$sql = "
	INSERT INTO users 
		(
			ip_address, 
			nonce, 
			avHardwareDisable, 
			hasAccessibility, 
			hasAudio, 
			hasAudioEncoder, 
			hasEmbeddedVideo, 
			hasIME, 
			hasMP3, 
			hasPrinting, 
			hasScreenBroadcast, 
			hasScreenPlayback, 
			hasStreamingAudio, 
			hasStreamingVideo, 
			hasTLS, 
			hasVideoEncoder, 
			isDebugger, 
			language, 
			localFileReadDisable, 
			manufacturer, 
			maxLevelIDC, 
			os, 
			pixelAspectRatio, 
			playerType, 
			screenColor, 
			screenDPI, 
			screenResolutionX, 
			screenResolutionY, 
			version, 		
			windowlessMode, 
			uagent) 
		VALUES (
			INET_ATON(?), ?, 
			?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 
			?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 
			?, ?, ?, ?, ?, ?, ?, ?, ?		
		)
";
	
	$stmt = $mysqli->prepare($sql);
	$stmt->bind_param("sssssssssssssssssssssssssssssss", 
		$ip, 
		$nonce,
		$avHardwareDisable, 
		$hasAccessibility, 
		$hasAudio, 
		$hasAudioEncoder, 
		$hasEmbeddedVideo, 
		$hasIME, 
		$hasMP3, 
		$hasPrinting, 
		$hasScreenBroadcast, 
		$hasScreenPlayback, 
		$hasStreamingAudio, 
		$hasStreamingVideo, 
		$hasTLS, 
		$hasVideoEncoder, 
		$isDebugger, 
		$language, 
		$localFileReadDisable, 
		$manufacturer, 
		$maxLevelIDC, 
		$os, 
		$pixelAspectRatio, 
		$playerType, 
		$screenColor, 
		$screenDPI, 
		$screenResolutionX, 
		$screenResolutionY, 
		$version,		
		$windowlessMode,
		$uagent
	);
	
	$stmt->execute();
	$stmt->close();
	
	$last_id = $mysqli->insert_id;
	
	echo "result=$last_id,$nonce";
	
}
elseif ($action == 'submit') {
	
	/* TODO: Add error checking here. */

	$ip = $_SERVER['REMOTE_ADDR'];
	$id = $_REQUEST['id'];
	$nonce = $_REQUEST['nonce'];
	
	if (!isset($_REQUEST['data'])) {
		echo "result=nodata";
		exit();
	}
	
	$data = $_REQUEST['data'];
	
	if (!isValidUser($id, $nonce)) {
		echo "result=fail";
		exit();		
	}
	
	# Perform work.
	foreach ($data as $d) {
		
		$darr = explode(',', $d);
		$name = $darr[0];		
		
		if ($name == 'Word_Submitted') {
			echo $d, "\n";
		}
		
		if ($name == 'Mouse_Position' or 
				$name == 'Mouse_Click' or 
				$name == 'Mouse_Unclick') {
			
			$event_type = strtoupper($name);
		
			$x = $darr[1];
			$y = $darr[2];
			$event_id = $darr[3];
			
			$sql = "INSERT INTO mouse_events (user_id, event_id, event_type, x, y) " 
				. " VALUES (?, ?, ?, ?, ?)";
	
			$stmt = $mysqli->prepare($sql);	
			$stmt->bind_param("iisii", $id, $event_id, $event_type, $x, $y);
			
			$stmt->execute();			
	
		}
		else if ($name == 'New_Rack' or $name == 'Word_Submitted') {
			
			$event_type = strtoupper($name); # Unused.
			
			if ($name == 'Word_Submitted') {
				$word = $darr[1];	
				$event_id = $darr[2];
			}			
			else {
				
				# Handle New Rack, mainly due to the word "empty".
				
				$word = '';
				
				# Skip index 0, which is the event name.
				# Skip the last index, which has the event_id.				
				for ($i = 1; $i < count($darr) - 1; ++$i) {
					if ($darr[$i] == 'empty') {
						$word .= ' ';
					}
					else {
						$word .= $darr[$i];
					}
					
				} 		
				
				$event_id = $darr[count($darr) - 1];
			}								
			
			$sql = "INSERT INTO word_events (user_id, event_id, event_type, word) " .
				" VALUES (?, ?, ?, ?)";
											
			$stmt = $mysqli->prepare($sql);					
			$stmt->bind_param('iiss', $id, $event_id, $event_type, $word);
						
			$stmt->execute();				
					
		}	
		else if ($name == 'Tile_Moved') {
			
			$event_type = strtoupper($name);
			$event_subtype = strtoupper($darr[1]);
			
			if ($event_subtype == 'BB') {
				$sql = "INSERT INTO tile_events " . 
				"(user_id, event_id, event_type, x_from, y_from, x_to, y_to) " .
				" VALUES (?, ?, ?, ?, ?, ?, ?)";
				
				$x_from = $darr[2];
				$y_from = $darr[3];
				$x_to = $darr[4];
				$y_to = $darr[5];
				
				$event_id = $darr[6];
				
				$stmt = $mysqli->prepare($sql);					
				$stmt->bind_param('iisiiii', $id, $event_id, $event_subtype, 
					$x_from, $y_from, $x_to, $y_to);
						
				$stmt->execute();				
			}
			else if ($event_subtype == 'BR') {
				$sql = "INSERT INTO tile_events " . 
				"(user_id, event_id, event_type, x_from, y_from, x_to, y_to) " .
				" VALUES (?, ?, ?, ?, ?, ?, ?)";
				
				$x_from = $darr[2];
				$y_from = $darr[3];
				$x_to = $darr[4];
				$y_to = 0;
				
				$event_id = $darr[5];
				
				$stmt = $mysqli->prepare($sql);					
				$stmt->bind_param('iisiiii', $id, $event_id, $event_subtype, 
					$x_from, $y_from, $x_to, $y_to);
					
				$stmt->execute();
				
			}						
			else if ($event_subtype == 'RB') {
				$sql = "INSERT INTO tile_events " . 
					"(user_id, event_id, event_type, x_from, y_from, x_to, y_to) " .
					" VALUES (?, ?, ?, ?, ?, ?, ?)";
					
					$x_from = $darr[2];
					$y_from = 0;
					$x_to = $darr[3];
					$y_to = $darr[4];
					
					$event_id = $darr[5];
					
					$stmt = $mysqli->prepare($sql);					
					$stmt->bind_param('iisiiii', $id, $event_id, $event_subtype, 
						$x_from, $y_from, $x_to, $y_to);
						
					$stmt->execute();
					
			}
			else if ($event_subtype == 'RS') {
				$sql = "INSERT INTO tile_events " . 
					"(user_id, event_id, event_type, x_from, y_from, x_to, y_to) " .
					" VALUES (?, ?, ?, ?, ?, ?, ?)";
					
					$x_from = $darr[2];
					$y_from = 0;
					$x_to = $darr[3];
					$y_to = 0;
					
					$event_id = $darr[4];
					
					$stmt = $mysqli->prepare($sql);					
					$stmt->bind_param('iisiiii', $id, $event_id, $event_subtype, 
						$x_from, $y_from, $x_to, $y_to);
						
					$stmt->execute();
			}
			else if ($event_subtype == 'SR') {
				
				$sql = "INSERT INTO tile_events " . 
					"(user_id, event_id, event_type, x_from, y_from, x_to, y_to) " .
					" VALUES (?, ?, ?, ?, ?, ?, ?)";
					
					$x_from = $darr[2];
					$y_from = 0;
					$x_to = $darr[3];
					$y_to = 0;
					
					$event_id = $darr[4];
					
					$stmt = $mysqli->prepare($sql);					
					$stmt->bind_param('iisiiii', $id, $event_id, $event_subtype, 
						$x_from, $y_from, $x_to, $y_to);
						
					$stmt->execute();
			}
						
		} // endif: Tile_Moved
		
		
	}
	
	echo "result=success";
}

/* Reply to Flash server. */
$mysqli->close();

?>
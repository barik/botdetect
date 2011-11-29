package 
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.net.*;
	import flash.utils.*;
	import flashx.textLayout.elements.InlineGraphicElement;
	import flash.system.Capabilities;
	

	public class engine extends MovieClip
	{

		// This holds the tile objects
		public var boardArray:Array = [];
		public var holdingTile:int = 0;
		public var newLetter:letters;
		
		public static const OFFSET:int = 40;
		
		public var startIndex:int = -1;
		public var startTopBottom:int = -1;
		
		// 0 = before game, 1 = during game, 2 = after game;
		public var gameMode:int = 0;
		public var readingText:int = 0;
		
		
		public var startXIndex:int = -1;
		public var startYIndex:int = -1;
		public var wordDict:wordDictionary;
		public var pressedEnter:int = 0;
		public var pressedShuffle:int = 0;
		public var pressedSwap:int = 0;
		public var pressedPass:int = 0;
		public var swappingTiles:int = 0;
		public var turn:int = 0;
		public var playerScore:int = 0;
		public var computerScore:int = 0;
		
		public var pressedSwapCancel:int = 0;
		public var pressedSwapEnter:int = 0;
		
		var scoreFormat:TextFormat;
		var scoreBox:TextField;
		
		var infoBox:TextField;
		var infoFormat:TextFormat;
		
		public var frameCount:int = 0;
		public var dataArray:Array = [];
		
		// Increment this with new builds to avoid confusion between new and cached copies.
		public static const VERSION:String = "1.5";
		
		// The number of points needed to win the game.
		// TODO: Computer does not win on correct turn. Example: Set points to 3.
		public static const POINTS_TO_WIN:int = 150;
		
		public static const WWF_URL:String = "http://ciigar.csc.ncsu.edu/tbarik/wwf/wwf.php";
		//public static const WWF_URL:String = "http://localhost/wwf/wwf.php";
		
		// POST variables
		public var variables:URLVariables;
		public var idArray:Array;
		
		// This tells me what's originally in each square (is it triple word, double letter, or what).
		public var boardSymbolArray:Array = [
		 ["tw", "em", "em", "dl", "em", "em", "em", "tw", "em", "em", "em", "dl", "em", "em", "tw"],
		 ["em", "dw", "em", "em", "em", "tl", "em", "em", "em", "tl", "em", "em", "em", "dw", "em"],
		 ["em", "em", "dw", "em", "em", "em", "dl", "em", "dl", "em", "em", "em", "dw", "em", "em"],
		 ["dl", "em", "em", "dw", "em", "em", "em", "dl", "em", "em", "em", "dw", "em", "em", "dl"],
		 ["em", "em", "em", "em", "dw", "em", "em", "em", "em", "em", "dw", "em", "em", "em", "em"],
		 ["em", "tl", "em", "em", "em", "tl", "em", "em", "em", "tl", "em", "em", "em", "tl", "em"],
		 ["em", "em", "dl", "em", "em", "em", "dl", "em", "dl", "em", "em", "em", "dl", "em", "em"],
		 ["tw", "em", "em", "dl", "em", "em", "em", "st", "em", "em", "em", "dl", "em", "em", "tw"],
		 ["em", "em", "dl", "em", "em", "em", "dl", "em", "dl", "em", "em", "em", "dl", "em", "em"],
		 ["em", "tl", "em", "em", "em", "tl", "em", "em", "em", "tl", "em", "em", "em", "tl", "em"],
		 ["em", "em", "em", "em", "dw", "em", "em", "em", "em", "em", "dw", "em", "em", "em", "em"],
		 ["dl", "em", "em", "dw", "em", "em", "em", "dl", "em", "em", "em", "dw", "em", "em", "dl"],
		 ["em", "em", "dw", "em", "em", "em", "dl", "em", "dl", "em", "em", "em", "dw", "em", "em"],
		 ["em", "dw", "em", "em", "em", "tw", "em", "em", "em", "tw", "em", "em", "em", "dw", "em"],
		 ["tw", "em", "em", "dl", "em", "em", "em", "tw", "em", "em", "em", "dl", "em", "em", "tw"]
		];

		// And no one really knows what this array does.
		public var boardTileArray:Array = [ 
		 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
		 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
		 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
		 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
		 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
		 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
		 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
		 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
		 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
		 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
		 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
		 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
		 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
		 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
		 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"]
		];

		public var alphabetArray:Array = ["a", "a", "a", "a", "a", "a", "a", "a", "a", "b", "b", "c", "c", "d", "d", "d", "d",
										  "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "f", "f", "g", "g", "g",
										  "g", "h", "h", "i", "i" ,"i", "i", "i", "i", "i", "i", "i", "j", "k", "l", "l", "l", 
										  "l", "m", "m", "n", "n", "n", "n", "n", "n", "o", "o", "o", "o", "o", "o", "o", "o", 
										  "p", "p", "q", "r", "r", "r", "r", "r", "r", "s", "s", "s", "s", "t", "t", "t", "t", 
										  "t" ,"t", "u", "u", "u", "u", "v", "v", "w", "w", "x", "y", "y", "z"];

		public var scoreDict:Object = {"a":1, "b":4, "c":4, "d":2, "e":1, "f":4, "g":3, "h":3, "i":1, "j":10, "k":5, "l":2, "m":4,
										"n":2, "o":1, "p":4, "q":10, "r":1, "s":1, "t":1, "u":2, "v":5, "w":4, "x":8, "y":3, "z":10};


		public var currentTiles:Array = [];
		public var currentSwapTiles:Array = [];

		public function engine():void
		{
			if (stage)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE,init);
			}
		}
		
		public function completeHandler(event:Event) {
			trace("Result: ");
			trace(event.target.data);
		}


		public function loginHandler(event:Event)
		{
			
			trace(event.target.data);
			
			idArray = event.target.data.replace(/result=/,"").split(",");
			var lastDitchArray:Array = [];
			for(var i:int = 0; i < idArray[1].length; i++)
			{
				if(idArray[1].charAt(i) != "\r" && idArray[1].charAt(i) != "\n")
				{
					lastDitchArray.push(idArray[1].charAt(i));
				}
			}
			idArray[1] = lastDitchArray.join("");
			trace(idArray[0],idArray[1]);
			
		}
		private function init(e:Event = null):void
		{
			
			
			/* Login */
			trace(Capabilities.serverString);
						
			variables = new URLVariables();			
			variables.decode(Capabilities.serverString);
			variables.client_version = VERSION;
			variables.action = "new";
			var request:URLRequest = new URLRequest(WWF_URL);
			request.data = variables;
			request.method = URLRequestMethod.POST;
						
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loginHandler);
					
			loader.load(request);	
			
					
			dataArray = [];
			scoreFormat = new TextFormat();
			scoreFormat.size = 30;
			scoreBox = new TextField();
			scoreBox.height = OFFSET;
			scoreBox.width = 525;
			scoreBox.defaultTextFormat = scoreFormat;
			scoreBox.text = "Player: 0				Computer: 0";
			addChild(scoreBox);
			wordDict = new wordDictionary();
			
			for (var i:int = 0; i < 15; i++)
			{
				var tempArray:Array = [];
				for (var j:int = 0; j < 15; j++)
				{
					var exampleTile:tiles = new tiles(boardSymbolArray[i][j]);
					tempArray.push(exampleTile);
				}
				boardArray.push(tempArray);
			}


			for (i = 0; i < 15; i++)
			{
				for (j = 0; j < 15; j++)
				{
					boardArray[i][j].x = j * 35;
					boardArray[i][j].y = i * 35 + OFFSET;
					addChild(boardArray[i][j]);
					boardArray[i][j].gotoAndStop(boardSymbolArray[i][j]);
				}
			}

			var tileFrame = new tileHolderFrame();
			tileFrame.y = 35 * 15 + OFFSET;
			tileFrame.x = 0;
			addChild(tileFrame);

			for (i = 0; i < 7; i++)
			{
				var randNum:int = Math.floor(Math.random() * alphabetArray.length);
				var holdTile = new holderTile(alphabetArray[randNum]);
				alphabetArray.splice(randNum,1);
				currentTiles.push(holdTile);
				currentTiles[i].x = 38 * i + 130;
				currentTiles[i].y = 35 * 15 + 8 + OFFSET;
				addChild(currentTiles[i]);
				currentTiles[i].gotoAndStop(currentTiles[i].stringData);
				var holdSwapTile:holderTile;
				currentSwapTiles.push(holdSwapTile);
			}

			var enterButton:button = new button("more");
			enterButton.x = 10;
			enterButton.y = 35 * 15 + 6 + OFFSET;
			addChild(enterButton);
			var shuffleButton:button = new button("shuffle");
			shuffleButton.x = 68;
			shuffleButton.y = 35*15+6 + OFFSET;
			addChild(shuffleButton);
			var swapButton:button = new button("swap");
			swapButton.x = 408;
			swapButton.y = 35*15+6 + OFFSET;
			addChild(swapButton);
			var passButton:button = new button("pass");
			passButton.x = 466;
			passButton.y = 35*15+6 + OFFSET;
			addChild(passButton);
			
			infoBox = new TextField();
			infoFormat = new TextFormat();
			infoFormat.size = 16;
			infoBox.height = 50;
			infoBox.width = 300;
			infoBox.x = 112.5;
			infoBox.y = 295;
			infoBox.defaultTextFormat = infoFormat;
			infoBox.background = true;
			infoBox.wordWrap = true;
			infoBox.autoSize = "left";
			infoBox.text = "Thank you for choosing to play Scrabblesque! " + 
				"The rules to this game are the same as the rules for Scrabble. " + 
				"Earn points by placing tiles on the board to make words. " + 
				"You will be going first. " + 
				"To begin, place a word through the star tile in the middle of the board. " + 
				"Remember that your words must use at least one letter from a word that already exists on the board. " + 
				"The game will end when either you or the computer gets to " + POINTS_TO_WIN + " points. " + 
				"Click anywhere to begin!";
				
			infoBox.text = infoBox.text + "\r\nVersion: " + VERSION;
			
			addChild(infoBox);
			addEventListener(Event.ENTER_FRAME, onFrameEnter);
			addEventListener(MouseEvent.MOUSE_DOWN, onClick);
			

		}

		public function onFrameEnter(e:Event=null):void
		{
						
			if (frameCount % 6 == 0) {
				
				if (dataArray.length > 0) {
				
					var last:Array = dataArray[dataArray.length - 1].split(",");				
					
					// Mouse position events occur extremely frequently.
					// Compress them by not adding a Mouse_Position
					// unless it is actually different from the previous position.
					if (last[0] == "Mouse_Position" && 
						(last[1] != mouseX || last[2] != mouseY)) {
											
							dataArray.push("Mouse_Position,"+mouseX+","+mouseY+","+getTimer());
					}					
				}
								
			}
			
			for (var i:int = numChildren-1; i >= 0; i--) {
				if (getChildAt(i) is letters) {
					MovieClip(getChildAt(i)).onFrameEnters();
				}
			}
						
			frameCount++;
			frameCount = frameCount % 6;
		}
		
		/** 
		 * Checks to see if there is an adjacent unlocked tile for a given tile.
		 * For any word except the first, one of the unlocked tiles 
		 * must be adjacent to an already locked tile.
		 */
		private function hasAdjacent(x:int, y:int): Boolean {
															
			if (x + 1 < 15 && boardTileArray[x + 1][y] == "lo") return true;
			else if (x - 1 > 0 && boardTileArray[x - 1][y] == "lo") return true;
			else if (y + 1 < 15 && boardTileArray[x][y + 1] == "lo") return true;
			else if (y - 1 > 0 && boardTileArray[x][y - 1] == "lo") return true;
			else return false;
		}
		
		/** 
		 * Returns the tile that is highest and leftmost of all other unlocked tiles.
		 * This is a useful function that is used by many other functions.
		 */
		private function findHighestTile(): Array {
						
			for (var i:int = 0; i < 15; i++) {
				for (var j:int = 0; j < 15; j++) {
					if (isUnlockedTile(i, j)) {
						return [i, j];						
					}																		
				}
			}
			
			return null;
			
		}
		
		/**
		 * Determine whether or not all tiles that you have placed are linear.
		 * That is, it is either horizontal or vertical with no empty spaces.
		 *
		 * The parameter needsLocked additionally checks to see that at least
		 * one of the tiles is touching an already placed tile.
		 */
		private function linearTiles(firstTurn:Boolean = false) {
						
			trace("Performing linear tiles test with firstTurn: " +firstTurn);
						
			var horiz:Boolean = false;
			var vertical:Boolean = false;
			
			var location:Array = findHighestTile();
			if (location == null) return false;
						
			var startX:int = location[0];
			var startY:int = location[1];			
			var endX:int = location[0];
			var endY:int = location[1];
			
			trace("Highest priority tile is: (" + startX + "," 
				  + startY + ") with " + boardTileArray[startX][startY] + ".");
			
			// Make sure that all new pieces are either horizontal or 
			// vertical, but don't care about gaps just yet. The
			// end of this loop will give us a starting and ending
			// range.
			for (var i:int = startX; i < 15; i++) {
				for (var j:int = startY; j < 15; j++) {
															
					// Determine unlocked tile, but ignore the highest priority
					// tile. Otherwise, you will set horizontal or vertical
					// with itself.
					if (isUnlockedTile(i, j) && !((i == startX) && (j == startY))) {												
						
						// trace("Unlocked tile: (" + i + "," + j + ")."); 
						
						if (startX == i && !vertical) {							
							endX = i;
							endY = j;							
							horiz = true;
						}						
						else if (startY == j && !horiz) {
							endX = i;
							endY = j;							
							vertical = true;
						}
						else {
							
							// We've hit a piece that isn't in the same row or
							// column as the highest priority tile.
							
							trace("Piece doesn't fit at all.");
							return false;
						}
					}										
				}
			} // end for
			
			trace("The word is horizontal: " + horiz);
			trace("The word is vertical: " + vertical);
			
			var hasAdjacentLocked:Boolean = false;
			
			// Using the horizontal flag, do a final pass to make sure 
			// that the tiles are contiguous.			
			if (horiz) {				
				for (j = startY; j <= endY; j++) {
					if (boardTileArray[startX][j] == "em") {
						
						trace("Board tile is empty at: (" + i + "," + startX +
							  ") for " + boardTileArray[startX][j]);
						
						return false;
					} 
					
					hasAdjacentLocked = hasAdjacentLocked || hasAdjacent(startX, j);					
				} // end for
			}
			else {
				for (i = startX; i <= endX; i++) {
					if (boardTileArray[i][startY] == "em") {	
					
						trace("Board tile is empty at: (" + i + "," + startY +
							  ") for "+ boardTileArray[i][startY]);
						
						return false;
					}
					
					hasAdjacentLocked = hasAdjacentLocked || hasAdjacent(i, startY);
				} // end for
			}
			
			if (firstTurn) {
				return true;
			}
			else if (hasAdjacentLocked) {
				trace("Linear test passed.");
				return true;
			}
			else {
				infoBox.text = "Your word must go through at least one letter " + 
					"of a word that is already on the board. Click anywhere to continue.";
				addChild(infoBox);
				readingText = 1;
			
				trace("Adjacent tile was not locked.");
				return false;
			}
		}
				
		function expandHorizontal(x:int, y:int): WordLine {
			
			trace("Expanding horizontal at: (" + x + "," + y + ") with " 
				  + boardTileArray[x][y] + ".");
			
			var startY:int = y;			
			var endY:int = y;
			
			while (startY - 1 >= 0 && boardTileArray[x][startY - 1] != "em") startY--;
			while (endY + 1 < 15 && boardTileArray[x][endY + 1] != "em") endY++;						
			
			if (startY == endY) return null;
			
			trace("Expanding horizontal y from " + startY + " to " + endY + ".");
			
			var word:String = ""
			for (var i:int = startY; i <= endY; i++) {				
				word = word + boardArray[x][i].stringData;				
			}
			
			return new WordLine(x, startY, x, endY, word);
			
			
		}
				
		function expandVertical(x:int, y:int): WordLine {
			
			var startX:int = x;
			var endX:int = x;
			
			while (startX - 1 >= 0 && boardTileArray[startX - 1][y] != "em") startX--;
			while (endX + 1 < 15 && boardTileArray[endX + 1][y] != "em") endX++;
			
			if (startX == endX) return null;
			
			var word:String = ""
			for (var j:int = startX; j <= endX; j++) {
				word = word + boardArray[j][y].stringData;
			}
			
			return new WordLine(startX, y, endX, y, word);
		}
		
		
		/**
		 * Returns true is the tile is unlocked, and false otherwise.
		 */
		function isUnlockedTile(x:int, y:int): Boolean {
			return boardTileArray[x][y] != "em" && boardTileArray[x][y] != "lo";
		}
		
		// This function returns a set of all new "words". Determination
		// of whether or not the word is actually a dictionary word
		// is performed at a later stage.
		//
		// By this point, linearTiles is assumed to be called, so we're
		// guaranteed that at least one new tile exists.
		function expandWords() : Array {			
		
			trace("Expanding words:");
			
			var wordLines:Array = [];
			
			var location:Array = findHighestTile();			
			var highX:int = location[0];
			var highY:int = location[1];
			
			var horizontalWord:WordLine = expandHorizontal(highX, highY);
			var verticalWord:WordLine = expandVertical(highX, highY);		
			
			// This can only happen on the first turn. You've placed
			// a single tile without any adjacencies.
			if (horizontalWord == null && verticalWord == null) {
				return [new WordLine(highX, highY, highX, highY, boardArray[highX][highY].stringData)];
			}
			else {
				if (horizontalWord) {
					wordLines.push(horizontalWord);
				}
				if (verticalWord) {
					wordLines.push(verticalWord);
				}
			}
			
			for (var i:int = highX + 1; i < 15; ++i) {
				for (var j:int = highY; j < 15; ++j) {
										
					// Expand vertically, since horizontal has already been expanded.
					if (isUnlockedTile(i,j) && i == highX) {
						
						verticalWord = expandVertical(i, j);
						if (verticalWord) {
							wordLines.push(verticalWord);
						}
												
					}
					
					// Expand horizontally, since vertical has already been expanded.
					if (isUnlockedTile(i, j) && i == highY) {
						
						horizontalWord = expandHorizontal(i, j);						
						if (horizontalWord) {							
							wordLines.push(horizontalWord);
						}
					}
				}
			}
			
			return wordLines;
			
		}
				
		function verifyTurn(firstTurn:Boolean = false) {
			
			// On the first turn, the center STAR tile needs to be covered.
			if (firstTurn && boardTileArray[7][7] == "em") {
				infoBox.text = "Your word needs to cross the star tile. " + 
					"Please Try Again. Click anywhere to continue.";
				
				addChild(infoBox);
				readingText = 1;
			
				return false;
			}
			
			return linearTiles(firstTurn);
					
		}
		
		function refillRack() {
			
			// TODO: Take all when rack needs more tiles than we actually have.
			
			// Refill the player's rack.
			for (var i:int = 0; i < currentTiles.length; i++) {
				if (currentTiles[i].stringData == "empty") {
					var randNum:int = Math.floor(Math.random() * alphabetArray.length);
					currentTiles[i].stringData = alphabetArray[randNum];
					alphabetArray.splice(randNum, 1);
					currentTiles[i].gotoAndStop(currentTiles[i].stringData);
				}
			} // end foreach							
			
			dataArray.push("New_Rack," + 
				currentTiles[0].stringData + "," + 
				currentTiles[1].stringData + "," +
				currentTiles[2].stringData + "," +
				currentTiles[3].stringData + "," +
				currentTiles[4].stringData + "," + 
				currentTiles[5].stringData + "," +
				currentTiles[6].stringData + "," +
				getTimer());
		}
		
		// Lock of all of the word tiles given a wordLines array.
		function lockWords(wordLines: Array) {
			for (var x:int = 0; x < wordLines.length; ++x) {
				var word:WordLine = wordLines[x];
				
				for (var i:int = word.startX; i <= word.endX; i++) {
					for (var j:int = word.startY; j <= word.endY; j++) {
						boardTileArray[i][j] = "lo";
						boardArray[i][j].valLock = 1;
					}
				}
				
			}
			
		}
		
		/**
		 * Calculates the score for a single word. Assumes that
		 * the word itself has already been validated.
		 */
		function calculateScoreForWord(word: WordLine):int {
			
			var score:int = 0;
			
			var doubleWord:int = 0;
			var tripleWord:int = 0;
			
			for (var i:int = word.startX; i <= word.endX; ++i) {
				for (var j:int = word.startY; j <= word.endY; ++j) {
					
					var letter:String = boardArray[i][j].stringData;
					var letterScore:int = scoreDict[letter];
					
					if (boardSymbolArray[i][j] == "dl") {
						letterScore *= 2;
					}
					else if (boardSymbolArray[i][j] == "tl") {
						letterScore *= 3;
					}
					else if (boardSymbolArray[i][j] == "dw") {
						doubleWord++;
					}
					else if (boardSymbolArray[i][j] == "dw") {
						doubleWord++;
					}
				
					trace("letterScore = " + letter + " " +  letterScore);
					score += letterScore;
				}
			}
			
			if (doubleWord > 0) {
				score = score * 2 * doubleWord;
			}
			
			if (tripleWord > 0) {
				score = score * 3 * tripleWord;
			}
			
			trace("Score for " + word.word + " is " + score);
			return score;
			
		}
		
		// Not sure why this should be any different than calculating the computer's score.
		// TODO: Refactor.
		function calculatePlayerScore(wordLines: Array):int {
			
			var score:int = 0;
			
			for (var i:int = 0; i < wordLines.length; ++i) {
				var word:WordLine = wordLines[i];
				score += calculateScoreForWord(word);
			}
			
			return score;
		}
		
		/**
		 * Clears all of the bonus tiles on the board so that they can't
		 * be re-used.
		 */
		function clearBonusTiles() {
			
			for (var i:int = 0; i < 15; i++) {
				for (var j:int = 0; j < 15; j++) {
					if (boardTileArray[i][j] == "lo") {
						// TODO: Should boardArray be changed here as well?
						boardSymbolArray[i][j] = "em";
					}
				}
			}
			
		}		
		
		/**
		 * Verify words. This function will check the wordLines against
		 * an actual dictionary to see if the words are in fact valid.
		 */
		function verifyWords(wordLines:Array):Boolean {
			
			for (var i:int = 0; i < wordLines.length; i++) {
						
				var word:WordLine = wordLines[i];
				
				dataArray.push("Word_Submitted," + word.word + "," + getTimer());
				
				trace("Found possible word: " + word.word);
				if (!wordDict.contains(word.word)) {
					trace(word.word + " is not a word");
					infoBox.text = "The word " + word.word + 
						" was not found. Please place another word and try again. Click anywhere to continue.";
					
					readingText = 1;
					addChild(infoBox);
					return false;
				}
				
			}
			
			return true;
		}
		
		/**
		 * Remove any stray tiles on the board and place them back
		 * on the rack.
		 */
		function removeStrayTiles() {
			for (var i:int = 0; i < 15; i++) {
				for (var j:int = 0; j < 15; j++) {
					
					if (boardArray[i][j].valLock != 1 && (boardArray[i][j].stringData != "tw" &&														 
														 boardArray[i][j].stringData != "tl" && 
														 boardArray[i][j].stringData != "dl" && 
														 boardArray[i][j].stringData != "dw" && 
														 boardArray[i][j].stringData != "em" && 
														 boardArray[i][j].stringData != "st")) {
						for (var k:int = 0; k < 7; k++) {
							
							if (currentTiles[k].stringData == "empty") {
								
								currentTiles[k].stringData = boardArray[i][j].stringData;
								currentTiles[k].gotoAndStop(currentTiles[k].stringData);
								
								boardArray[i][j].stringData = boardSymbolArray[i][j];
								boardArray[i][j].gotoAndStop(boardArray[i][j].stringData);
								
								break;
							}
							
						} // end for
					} // end if
				} // end for j
			} // end for i
			
		}
		
		function onClick(eventObject:MouseEvent)
		{
			
			
			dataArray.push("Mouse_Click,"+mouseX+","+mouseY+","+getTimer());
			if (swappingTiles != 1 && gameMode == 1 && readingText == 0) {
				if (mouseY >= 35*15+8 + OFFSET && mouseY <= 35*15+48 + OFFSET) {
					var index:int = -1;
					
					// User pressed the enter button.
					if (mouseX >=10 && mouseX <=60)
					{
						pressedEnter = 1;
						removeEventListener(MouseEvent.MOUSE_DOWN, onClick);
						addEventListener(MouseEvent.MOUSE_UP, onUnclick);
					}	
					
					// User pressed the shuffle button.
					else if(mouseX >= 68 && mouseX <= 117)
					{
						pressedShuffle = 1;
						removeEventListener(MouseEvent.MOUSE_DOWN, onClick);
						addEventListener(MouseEvent.MOUSE_UP, onUnclick);
					}
					
					// User pressed the swap button.
					else if(mouseX >= 408 && mouseX <= 458)
					{
						pressedSwap = 1;
						removeEventListener(MouseEvent.MOUSE_DOWN, onClick);
						addEventListener(MouseEvent.MOUSE_UP, onUnclick);
					}		
					
					// User pressed the pass button.
					else if(mouseX >= 466 && mouseX <= 516)
					{
						pressedPass = 1;
						removeEventListener(MouseEvent.MOUSE_DOWN, onClick);
						addEventListener(MouseEvent.MOUSE_UP, onUnclick);
					}
										
					else
					{
						for (var i = 0; i < 7; i++)
						{
							if (mouseX >= 38*i+130 && mouseX <= 38*(i+1)+130)
							{
								index = i;
							}	
						}
					}

					if (index != -1 && currentTiles[index].stringData != "empty")
					{
						newLetter = new letters(currentTiles[index].stringData);
						currentTiles[index].stringData = "empty";
						currentTiles[index].gotoAndStop(currentTiles[index].stringData);
						addChild(newLetter);
						newLetter.gotoAndStop(newLetter.stringData);
						newLetter.x = mouseX - 25;
						newLetter.y = mouseY - 10;
						removeEventListener(MouseEvent.MOUSE_DOWN, onClick);
						addEventListener(MouseEvent.MOUSE_UP, onUnclick);
						holdingTile = 1;
						startIndex = index;
					}
				} // mouseY >= 35*15+8 + OFFSET && mouseY <= 35*15+48 + OFFSET
				
				else if (mouseY <= 35*15 + OFFSET)
				{
					var xIndex:int = -1;
					var yIndex:int = -1;
					for (i = 0; i < 15; i++)
					{
						if (mouseX >= 35*i && mouseX <= 35*(i+1))
						{
							xIndex = i;
						}
						if (mouseY >= 35*i + OFFSET && mouseY <= 35*(i+1) + OFFSET)
						{
							yIndex = i;
						}
					}

					if (xIndex != -1 && yIndex != -1)
					{
						if (!(boardArray[yIndex][xIndex].valLock == 1 || boardArray[yIndex][xIndex].stringData == "em" || boardArray[yIndex][xIndex].stringData == "dw" || boardArray[yIndex][xIndex].stringData == "dl" || boardArray[yIndex][xIndex].stringData == "tw" || boardArray[yIndex][xIndex].stringData == "tl" || boardArray[yIndex][xIndex].stringData == "st"))
						{
							startXIndex = xIndex;
							startYIndex = yIndex;
							boardTileArray[startYIndex][startXIndex] = "em";
							newLetter = new letters(boardArray[yIndex][xIndex].stringData);
							boardArray[yIndex][xIndex].stringData = boardSymbolArray[yIndex][xIndex];
							boardArray[yIndex][xIndex].gotoAndStop(boardArray[yIndex][xIndex].stringData);
							addChild(newLetter);
							newLetter.gotoAndStop(newLetter.stringData);
							newLetter.x = mouseX - 25;
							newLetter.y = mouseY - 10;
							removeEventListener(MouseEvent.MOUSE_DOWN, onClick);
							addEventListener(MouseEvent.MOUSE_UP, onUnclick);
							holdingTile = 1;
						}
					}
				}

			}
			else if(gameMode == 1 && readingText == 0 && swappingTiles == 1 && mouseY >=(35*15)-49 + OFFSET && mouseY <= 35*15+48 + OFFSET)
			{
				//We'll do pressing the cancel on the swap thing for now
				if(mouseY <= (35*15)-9 + OFFSET && mouseX >= 408 && mouseX <= 458)
				{
					pressedSwapCancel = 1;
					removeEventListener(MouseEvent.MOUSE_DOWN, onClick);
					addEventListener(MouseEvent.MOUSE_UP, onUnclick);
				}
				else if(mouseY <= (35*15)-9 + OFFSET && mouseX >= 68 && mouseX <= 117)
				{
					trace("Pressing enter");
					pressedSwapEnter = 1;
					removeEventListener(MouseEvent.MOUSE_DOWN, onClick);
					addEventListener(MouseEvent.MOUSE_UP, onUnclick);
				}
				else if(mouseY >= 35*15+8 + OFFSET && mouseY <= 35*15+48 + OFFSET)
				{
					index = -1;
					//Time to pick up some bottom tiles!
					for (i = 0; i < 7; i++)
					{
						if (mouseX >= 38*i+130 && mouseX <= 38*(i+1)+130)
						{
							index = i;
						}		
					}

					if (index != -1 && currentTiles[index].stringData != "empty")
					{
						newLetter = new letters(currentTiles[index].stringData);
						currentTiles[index].stringData = "empty";
						currentTiles[index].gotoAndStop(currentTiles[index].stringData);
						addChild(newLetter);
						newLetter.gotoAndStop(newLetter.stringData);
						newLetter.x = mouseX - 25;
						newLetter.y = mouseY - 10;
						removeEventListener(MouseEvent.MOUSE_DOWN, onClick);
						addEventListener(MouseEvent.MOUSE_UP, onUnclick);
						holdingTile = 1;
						startIndex = index;
						//Refers to it starting in the bottom frame
						startTopBottom = 1;
					}
				}
				else if(mouseY >= (35*15)-46 + OFFSET && mouseY <= 35*15 - 9 + OFFSET)
				{
					index = -1;
					for(i = 0; i < 7; i++)
					{
						if(mouseX >= 38*i+130 && mouseX <= 38*(i+1)+130)
						{
							index = i;
						}
					}
					if (index != -1 && currentSwapTiles[index].stringData != "empty")
					{
						newLetter = new letters(currentSwapTiles[index].stringData);
						currentSwapTiles[index].stringData = "empty";
						currentSwapTiles[index].gotoAndStop(currentSwapTiles[index].stringData);
						addChild(newLetter);
						newLetter.gotoAndStop(newLetter.stringData);
						newLetter.x = mouseX - 25;
						newLetter.y = mouseY - 10;
						removeEventListener(MouseEvent.MOUSE_DOWN, onClick);
						addEventListener(MouseEvent.MOUSE_UP, onUnclick);
						holdingTile = 1;
						startIndex = index;
						//Refers to it starting in the bottom frame
						startTopBottom = 0;
					}
					
				}
			}
			addEventListener(MouseEvent.MOUSE_UP, onUnclick);
		}

		/**
		 * The Player has pressed the submit button.
		 */
		public function pressSubmitButton() {
			
			// Submit Log Data
			variables = new URLVariables();
			variables.debug = true;
			variables.id = idArray[0];
			variables.nonce = idArray[1];
			variables.action = "submit";
			variables["data[]"] = dataArray;
			var request:URLRequest = new URLRequest(WWF_URL);
			request.data = variables;
			request.method = URLRequestMethod.POST;
					
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, completeHandler);
				
			loader.load(request);	
			dataArray = [];
			
			// It's time to verify the word choice. Using the new, fancy way!										
			trace("Verifying tiles at turn " + turn + ".");
			
			if (!verifyTurn(turn == 0)) {

				// Use this generic message if a more specific message
				// has not already been set.
				if (readingText != 1) {
					trace("Invalid Board Configuration");
					infoBox.text = "Invalid board configuration. Click anywhere to continue.";
					addChild(infoBox);
					readingText = 1;
				}
				return;
			}					
								
			var wordLines = expandWords();
			var word:WordLine;															
								
			// If you can't verify the words, then back out.
			if (!verifyWords(wordLines)) {
				return;
			}
								
			// Lock all of the words, since we've verified that they are correct.
			lockWords(wordLines);		
			
			// Calculate the player's score.
			playerScore += calculatePlayerScore(wordLines);
			
			trace("Player Score: " + playerScore);
			trace("Computer Score: "+ computerScore);
			scoreBox.text = "Player: " + playerScore + "				Computer: " + computerScore;
			
			if(playerScore >= POINTS_TO_WIN) {
				gameMode = 3;
				infoBox.text = "You Won! Thank you for playing. Click anywhere to play again";
				addChild(infoBox);
				
				// Might as well re-post items.
				variables = new URLVariables();
				variables.debug = true;
				variables.id = idArray[0];
				variables.nonce = idArray[1];
				variables.action = "submit";
				variables["data[]"] = dataArray;
				request = new URLRequest(WWF_URL);
				request.data = variables;
				request.method = URLRequestMethod.POST;
		
				loader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, completeHandler);
		
				loader.load(request);	
				dataArray = [];
				
				return;
			}

			// Clear bonus tiles.
			clearBonusTiles();

			// Refill the rack.
			refillRack();				
		
			turn++;										
			computerGo();
			
		}
		
		/**
		 * Determines if the all the letters for the word
		 * are available in the unused tile bag.		
		 */
		private function areLettersAvailable(word:String):Boolean {
												
			var randWordArray:Array = word.split("");
			
			// Make a shallow copy of the alphabet array.
			var localAlphabetArray = alphabetArray.concat();
			
			for(var i:int = 0; i < randWordArray.length; i++) {
				
				var indexOf:int = localAlphabetArray.indexOf(randWordArray[i]);
						
				// Could not find the letter in the alphabet array.
				if (indexOf == -1) {
					return false;
				}	
				else {
					// Remove the letter from the local array and continue.
					localAlphabetArray.splice(indexOf, 1);
				}
			}
			
			return true;
			
		}
		
		/**
		 * Have the computer return a word by laying a tile across the
		 * star horizontally. This only applies if the Player has
		 * decided to skip their first turn.
		 */
		private function computeStarWord():String {
						
			var word:String;
			
			while(true) {
									
				word = wordDict.random();				
				if (areLettersAvailable(word)) {
					break;
				}
				
			}
			
			return word;
			
		}
		
		/**
		 * This turn is only used when the Player passes or swaps their
		 * tiles so that the star is still available.
		 */
		private function computerStarTurn() {
						
			var randWord:String = computeStarWord();
			var randWordArray:Array = randWord.split("");
			
			// Place the tiles for the selected word on the board.
			for (var i:int = 0; i < randWordArray.length; ++i) {
				
				// Remove the tile from the unused tile bag.
				alphabetArray.splice(alphabetArray.indexOf(randWordArray[i]), 1);
				
				boardTileArray[7][i+7] = randWordArray[i];
				boardArray[7][i+7].stringData = randWordArray[i];
				boardArray[7][i+7].gotoAndStop(boardArray[7][i+7].stringData);				
			}
						
			// Generate list of words; assume valid since the computer
			// is the one who generated them in the first place.
			var wordLines:Array = expandWords();
			
			// Lock these tiles.
			lockWords(wordLines);			
			
			// Calculate a score.
			computerScore += calculatePlayerScore(wordLines);
						
			// Remove bonus tiles.
			clearBonusTiles();
			
			trace("Player Score: " + playerScore);
			trace("Computer Score: " + computerScore);
			scoreBox.text = "Player: " + playerScore + "				Computer: "+computerScore;
			
		}
		
		/**
		 * The Player has pressed the pass button.
		 */
		public function pressPassButton() {
			
			turn++;
					
			variables = new URLVariables();
			variables.debug = true;
			variables.id = idArray[0];
			variables.nonce = idArray[1];
			variables.action = "submit";
			variables["data[]"] = dataArray;
			var request:URLRequest = new URLRequest(WWF_URL);
			request.data = variables;
			request.method = URLRequestMethod.POST;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, completeHandler);
				
			loader.load(request);
			dataArray = [];
			
			// Remove stray tiles on the board and put them back on the rack.
			removeStrayTiles();				
			
			// Next have the computer take it's turn, IF it's the first turn, just lay a tile on the star horizontally
			if (turn == 1) {
				computerStarTurn();
			}
			else {
				computerGo();
			}
			
		}

		/**
		 * The Player has pressed the shuffle button.
		 */
		public function pressShuffleButton() {
			
			var permutationArray:Array = [];
			
			for(var i:int = 0; i < 7; i++) {
				permutationArray.push(i);
			}
			
			for(i = 0; i < 7; i++)
			{
				var randIndex:int = Math.floor(Math.random() * 7);
				
				// Swap i with randIndex
				var tempString:String = currentTiles[i].stringData;
				currentTiles[i].stringData = currentTiles[randIndex].stringData;
				currentTiles[randIndex].stringData = tempString;
				currentTiles[i].gotoAndStop(currentTiles[i].stringData);
				currentTiles[randIndex].gotoAndStop(currentTiles[randIndex].stringData);
			}
			
			dataArray.push("New_Rack," + 
						   currentTiles[0].stringData + "," + 
						   currentTiles[1].stringData + "," +
						   currentTiles[2].stringData + "," + 
						   currentTiles[3].stringData + "," +
						   currentTiles[4].stringData + "," +
						   currentTiles[5].stringData + "," +
						   currentTiles[6].stringData + "," + 
						   getTimer());
			
		}

		function onUnclick(eventObject:MouseEvent) {
			
			dataArray.push("Mouse_Unclick," + mouseX + "," +mouseY + "," +getTimer());
			
			if(swappingTiles != 1 && gameMode == 1 && readingText == 0) {
				for (var i:int = numChildren-1; i >= 0; i--)
				{
					if (getChildAt(i) is letters)
					{
						removeChildAt(i);
						holdingTile = 0;

					}
				}
				if (newLetter != null && mouseY >= 35*15+1 + OFFSET && mouseY <= 35*15+48 + OFFSET)
				{
					var index:int = -1;
					for (i = 0; i < 7; i++)
					{
						if (mouseX >= 38*i+130 && mouseX <= 38*(i+1)+130)
						{
							index = i;
						}
					}
					
					
					if (index != -1)
					{
						//Dropping Tiles in the rack
						
						if (currentTiles[index].stringData == "empty")
						{
							if(startIndex != -1)
							{
								dataArray.push("Tile_Moved,RR,"+startIndex+","+index+","+getTimer());
							}
							else if(startXIndex != -1 && startYIndex != -1)
							{
								dataArray.push("Tile_Moved,BR,"+startXIndex+","+startYIndex+","+index+","+getTimer());
							}
							currentTiles[index].stringData = newLetter.stringData;
							currentTiles[index].gotoAndStop(currentTiles[index].stringData);
							newLetter = null;
						}
						else if (startIndex != -1)
						{
							dataArray.push("Tile_Moved,RR,"+startIndex+","+index+","+getTimer());
							
							var tempString:String = currentTiles[index].stringData;
							currentTiles[index].stringData = newLetter.stringData;
							currentTiles[index].gotoAndStop(currentTiles[index].stringData);
							currentTiles[startIndex].stringData = tempString;
							currentTiles[startIndex].gotoAndStop(currentTiles[startIndex].stringData);
							newLetter = null;
						}
						else if (startXIndex != -1 && startYIndex != -1)
						{
							//Not sure how to handle this event. If you move from the board into the rack. How do we log the data
							for (i = 0; i < 7; i++)
							{
								if (currentTiles[i].stringData == "empty")
								{
									currentTiles[i].stringData = newLetter.stringData;
									currentTiles[i].gotoAndStop(currentTiles[i].stringData);
									newLetter = null;
									break;
								}
							}
						}
					}
					else if (startIndex != -1)
					{
						//Possible Error Move
						currentTiles[startIndex].stringData = newLetter.stringData;
						currentTiles[startIndex].gotoAndStop(currentTiles[startIndex].stringData);
						newLetter = null;
					}
					else if (startXIndex != -1 && startYIndex != 1)
					{
						//Possible Error Move
						boardArray[startYIndex][startXIndex].stringData = newLetter.stringData;
						boardArray[startYIndex][startXIndex].gotoAndStop(boardArray[startYIndex][startXIndex].stringData);
						newLetter = null;
					}
				}
				else if (mouseY <= 35*15 + OFFSET && mouseY > OFFSET)
				{
					//Dropping tiles on the board
					
					var xIndex:int = -1;
					var yIndex:int = -1;
					for (i = 0; i < 15; i++)
					{
						if (mouseX >= 35*i && mouseX <= 35*(i+1))
						{
							xIndex = i;
						}
						if (mouseY >= 35*i + OFFSET && mouseY <= 35*(i+1) + OFFSET)
						{
							yIndex = i;
						}	
					}
	
					if (xIndex != -1 && yIndex != -1)
					{
						if (newLetter != null && (boardArray[yIndex][xIndex].stringData == "em" || boardArray[yIndex][xIndex].stringData == "dw" || boardArray[yIndex][xIndex].stringData == "dl" || boardArray[yIndex][xIndex].stringData == "tw" || boardArray[yIndex][xIndex].stringData == "tl" || boardArray[yIndex][xIndex].stringData == "st"))
						{
							if(startIndex != -1)
							{
								dataArray.push("Tile_Moved,RB,"+startIndex+","+xIndex+","+yIndex+","+getTimer());
							}
							else if(startYIndex != 1 && startXIndex != 1)
							{
								dataArray.push("Tile_Moved,BB"+startXIndex+","+startYIndex+","+xIndex+","+yIndex+","+getTimer());
							}
							boardArray[yIndex][xIndex].stringData = newLetter.stringData;
							boardTileArray[yIndex][xIndex] = newLetter.stringData;
							boardArray[yIndex][xIndex].gotoAndStop(boardArray[yIndex][xIndex].stringData);
							newLetter = null;
						}
						else if (newLetter != null && !(boardArray[yIndex][xIndex].stringData == "em" || boardArray[yIndex][xIndex].stringData == "dw" || boardArray[yIndex][xIndex].stringData == "dl" || boardArray[yIndex][xIndex].stringData == "tw" || boardArray[yIndex][xIndex].stringData == "tl" || boardArray[yIndex][xIndex].stringData == "st"))
						{
							if (startIndex != -1)
							{
								//Possible error move?
								currentTiles[startIndex].stringData = newLetter.stringData;
								currentTiles[startIndex].gotoAndStop(currentTiles[startIndex].stringData);
								newLetter = null;
							}
							else if (startXIndex != -1 && startYIndex != -1)
							{
								//Moving from board tile to board tile only if it's not locked
								if (boardArray[yIndex][xIndex].valLock == 0)
								{
									dataArray.push("Tile_Moved,BB"+startXIndex+","+startYIndex+","+xIndex+","+yIndex+","+getTimer());
									tempString = boardArray[yIndex][xIndex].stringData;
									boardArray[yIndex][xIndex].stringData = newLetter.stringData;
									boardTileArray[yIndex][xIndex] = newLetter.stringData;
									boardArray[startYIndex][startXIndex].stringData = tempString;
									boardTileArray[startYIndex][startXIndex] = tempString;
									boardArray[startYIndex][startXIndex].gotoAndStop(boardArray[startYIndex][startXIndex].stringData);
									boardArray[yIndex][xIndex].gotoAndStop(boardArray[yIndex][xIndex].stringData);
								}
								//possible error move
								else
								{
									boardArray[startYIndex][startXIndex].stringData = newLetter.stringData;
									boardArray[startYIndex][startXIndex].gotoAndStop(boardArray[startYIndex][startXIndex].stringData);
									boardTileArray[startYIndex][startXIndex] = boardArray[startYIndex][startXIndex].stringData;
								}
								newLetter = null;
							}
						}
					}
				}

				else if (mouseY > 35*15+48 + OFFSET)
				{
					//Error Moves
					if (startIndex != -1)
					{
						currentTiles[startIndex].stringData = newLetter.stringData;
						currentTiles[startIndex].gotoAndStop(currentTiles[startIndex].stringData);
						newLetter = null;
					}
					else if (startXIndex != -1 && startYIndex != -1)
					{
						boardArray[startYIndex][startXIndex].stringData = newLetter.stringData;
						boardArray[startYIndex][startXIndex].gotoAndStop(boardArray[startYIndex][startXIndex].stringData);
						newLetter = null;
					}
				}
				
				else if (newLetter != null && mouseY <= OFFSET)
				{
					//Error moves
					if(startIndex != -1)
					{
						currentTiles[startIndex].stringData = newLetter.stringData;
						currentTiles[startIndex].gotoAndStop(currentTiles[startIndex].stringData);
					}
					else
					{
						boardArray[startYIndex][startXIndex].stringData = newLetter.stringData;
						boardTileArray[startYIndex][startXIndex] = newLetter.stringData;
						boardArray[startYIndex][startXIndex].gotoAndStop(boardArray[startYIndex][startXIndex]);
					}
					holdingTile = 0;
					newLetter = null;
				}
				
				else if (pressedShuffle == 1 && mouseY >=35*15+8 + OFFSET && mouseY <= 35*15+48 + OFFSET && mouseX >= 68 && mouseX <=117) {
					pressShuffleButton();
								
				}
				else if (pressedSwap == 1 && mouseY >= 35*15+8 + OFFSET && mouseY <= 35*15+48 + OFFSET && mouseX >= 408 && mouseX <= 458)
				{
					//load up our swap thing and probably set a swapping tiles flag that will negate a LOT of things
					var swapBar:swapFrame = new swapFrame();
					swapBar.x = 64
					swapBar.y = (35*15)-55 + OFFSET;
					addChild(swapBar);
					//Create some buttons
					var swapEnter:button = new button("more");
					swapEnter.x = 68;
					swapEnter.y = (35*15)-49 + OFFSET;
					addChild(swapEnter);
					var swapCancel:button = new button("cancel");
					swapCancel.x = 408;
					swapCancel.y = (35*15)-49 + OFFSET;
					addChild(swapCancel);
					swappingTiles = 1;
					
					for(i = 0; i < 7; i++)
					{
						currentSwapTiles[i] = new holderTile("empty");
						currentSwapTiles[i].y = (35*15)-55 + 8 + OFFSET;
						currentSwapTiles[i].x = 38 * i + 130;
						addChild(currentSwapTiles[i]);
						currentSwapTiles[i].gotoAndStop(currentSwapTiles[i].stringData);
					}
					trace("Entering Swap Tiles Mode");
				}
				
				// The player has hit the pass button.
				else if(pressedPass == 1 && mouseY>= 35*15+8 + OFFSET && 
						mouseY <= 35*15+48 + OFFSET && 
						mouseX >= 466 && mouseX <= 516) {
					
					pressPassButton();
					
				}
				
				// The player has hit the submit button.
				else if (pressedEnter == 1 && mouseY >= 35*15+8 + OFFSET && 
						 mouseY <= 35*15+48 + OFFSET && mouseX >=10 && 
						 mouseX <=60) {					
					
					pressSubmitButton();
				}
														
			} // What the heck is this closing? Swap mode?
			else if(swappingTiles == 1 && gameMode == 1 && readingText == 0)
			{
				if(pressedSwapCancel == 1 && mouseY <= (35*15)-9 + OFFSET && mouseX >= 408 && mouseX <= 458 && mouseY >=(35*15)-49 + OFFSET)
				{
					trace("Cancelling Swap");
					//Check to see if anything is the the swap tileset
					for(i = 0; i < 7; i++)
					{
						if(currentSwapTiles[i].stringData != "empty")
						{
							for(var j:int = 0; j < 7; j++)
							{
								if(currentTiles[j].stringData == "empty")
								{
									currentTiles[j].stringData = currentSwapTiles[i].stringData;
									currentTiles[j].gotoAndStop(currentTiles[j].stringData);
									break;
								}
							}
						}
						//currentSwapTiles[i] = null;
					}
					
					// Remove buttons
					for(j = 0; j < 3; j++)
					{
						for (i = numChildren-1; i >= 0; i--)
						{
							if (getChildAt(i) is swapFrame || getChildAt(i) is button)
							{
								removeChildAt(i);
								break;
							}
						}
					}
					for(j = 0; j < 7; j++)
					{
						for(i = numChildren-1; i >=0; i--)
						{
							if(getChildAt(i) is holderTile)
							{
								removeChildAt(i);
								break;
							}
						}
					}
					for(i = 0; i < 7; i++)
					{
						currentSwapTiles[i] = null;
					}
					swapBar = null;
					swapEnter = null;
					swapCancel = null;
					swappingTiles = 0;
				}
				
				else if(pressedSwapEnter == 1 &&  mouseY <= (35*15)-9 + OFFSET && mouseX >= 68 && mouseX <= 117 && mouseY >=(35*15)-49 + OFFSET)
				{
					for(i = 0; i < 7; i++)
					{
						if(currentTiles[i].stringData == "empty")
						{
							var randNum = Math.floor(Math.random() * (alphabetArray.length));
							currentTiles[i].stringData = alphabetArray[randNum];
							alphabetArray.splice(randNum, 1);
							currentTiles[i].gotoAndStop(currentTiles[i].stringData);
						}
						   
					}
					dataArray.push("New_Rack,"+currentTiles[0].stringData+","+currentTiles[1].stringData+","+currentTiles[2].stringData+","+currentTiles[3].stringData+","+currentTiles[4].stringData+","+currentTiles[5].stringData+","+currentTiles[6].stringData+","+getTimer());
					for(i = 0; i < 7; i++)
					{
						if(currentSwapTiles[i].stringData != "empty")
						{
							alphabetArray.push(currentSwapTiles[i].stringData);
						}
					}
					for(j = 0; j < 3; j++)
					{
						for (i = numChildren-1; i >= 0; i--)
						{
							if (getChildAt(i) is swapFrame || getChildAt(i) is button)
							{
								removeChildAt(i);
								break;
							}
						}
					}
					for(j = 0; j < 7; j++)
					{
						for(i = numChildren-1; i >=0; i--)
						{
							if(getChildAt(i) is holderTile)
							{
								removeChildAt(i);
								break;
							}
						}
					}
					for(i = 0; i < 7; i++)
					{
						currentSwapTiles[i] = null;
					}
					swapBar = null;
					swapEnter = null;
					swapCancel = null;
					swappingTiles = 0;
					
					// swap is like pass.. this code has to be redone
					turn++;
					if(turn == 1) {
						computerStarTurn();
					}
					else {
						computerGo();
					}
					
				}
				
				else if(holdingTile == 1)
				{
					var top:int = 0;
					var bottom:int = 0;
					for (i = 0; i < 7; i++)
					{
						if (mouseX >= 38*i+130 && mouseX <= 38*(i+1)+130 && mouseY >= 35*15+1+OFFSET && mouseY <= 35*15+48+OFFSET)
						{
							//Placing tile from swap rack to rack
							if(currentTiles[i].stringData == "empty")
							{
								dataArray.push("Tile_Moved,SR,"+i+","+startIndex+","+getTimer());
								currentTiles[i].stringData = newLetter.stringData;
								currentTiles[i].gotoAndStop(currentTiles[i].stringData);
								bottom = 1;
								break;
							}
						}	
					}
					if(bottom != 1)
					{
						for(i = 0; i < 7; i++)
						{
							if(mouseX >= 38*i+130 && mouseX <= 38*(i+1)+130 && mouseY >= (35*15)-55 + 8 + OFFSET && mouseY <= (35*15)-55+48+OFFSET)
							{
								//Placing tile from rack to swap rack
								if(currentSwapTiles[i].stringData == "empty")
								{
									dataArray.push("Tile_Moved,RS,"+startIndex+","+i+","+getTimer());
									currentSwapTiles[i].stringData = newLetter.stringData;
									currentSwapTiles[i].gotoAndStop(currentSwapTiles[i].stringData);
									top = 1;
									break;
								}
							}
						}
					}
					if(top != 1 && bottom != 1)
					{
						if(startTopBottom == 1)
						{
							currentTiles[startIndex].stringData = newLetter.stringData;
							currentTiles[startIndex].gotoAndStop(currentTiles[startIndex].stringData);
						}
						else if(startTopBottom == 0)
						{
							currentSwapTiles[startIndex].stringData = newLetter.stringData;
							currentSwapTiles[startIndex].gotoAndStop(currentSwapTiles[startIndex].stringData);
						}
					}
					for (i = numChildren-1; i >= 0; i--)
					{
						if (getChildAt(i) is letters)
						{
							removeChildAt(i);
							holdingTile = 0;
						}
					}
					newLetter = null;
				}
			}
			else if(gameMode == 0)
			{
				gameMode = 1;
				removeChild(infoBox);
			}
			else if(readingText == 1)
			{
				readingText = 0;
				removeChild(infoBox);
			}
			else if(gameMode == 3)
			{
				//reset everything
				boardSymbolArray = [
				 ["tw", "em", "em", "dl", "em", "em", "em", "tw", "em", "em", "em", "dl", "em", "em", "tw"],
				 ["em", "dw", "em", "em", "em", "tl", "em", "em", "em", "tl", "em", "em", "em", "dw", "em"],
				 ["em", "em", "dw", "em", "em", "em", "dl", "em", "dl", "em", "em", "em", "dw", "em", "em"],
				 ["dl", "em", "em", "dw", "em", "em", "em", "dl", "em", "em", "em", "dw", "em", "em", "dl"],
				 ["em", "em", "em", "em", "dw", "em", "em", "em", "em", "em", "dw", "em", "em", "em", "em"],
				 ["em", "tl", "em", "em", "em", "tl", "em", "em", "em", "tl", "em", "em", "em", "tl", "em"],
				 ["em", "em", "dl", "em", "em", "em", "dl", "em", "dl", "em", "em", "em", "dl", "em", "em"],
				 ["tw", "em", "em", "dl", "em", "em", "em", "st", "em", "em", "em", "dl", "em", "em", "tw"],
				 ["em", "em", "dl", "em", "em", "em", "dl", "em", "dl", "em", "em", "em", "dl", "em", "em"],
				 ["em", "tl", "em", "em", "em", "tl", "em", "em", "em", "tl", "em", "em", "em", "tl", "em"],
				 ["em", "em", "em", "em", "dw", "em", "em", "em", "em", "em", "dw", "em", "em", "em", "em"],
				 ["dl", "em", "em", "dw", "em", "em", "em", "dl", "em", "em", "em", "dw", "em", "em", "dl"],
				 ["em", "em", "dw", "em", "em", "em", "dl", "em", "dl", "em", "em", "em", "dw", "em", "em"],
				 ["em", "dw", "em", "em", "em", "tw", "em", "em", "em", "tw", "em", "em", "em", "dw", "em"],
				 ["tw", "em", "em", "dl", "em", "em", "em", "tw", "em", "em", "em", "dl", "em", "em", "tw"]
				];

				boardTileArray = [ 
				 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
				 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
				 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
				 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
				 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
				 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
				 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
				 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
				 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
				 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
				 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
				 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
				 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
				 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"],
				 ["em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em", "em"]
				];
				alphabetArray = ["a", "a", "a", "a", "a", "a", "a", "a", "a", "b", "b", "c", "c", "d", "d", "d", "d",
										  "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "e", "f", "f", "g", "g", "g",
										  "g", "h", "h", "i", "i" ,"i", "i", "i", "i", "i", "i", "i", "j", "k", "l", "l", "l", 
										  "l", "m", "m", "n", "n", "n", "n", "n", "n", "o", "o", "o", "o", "o", "o", "o", "o", 
										  "p", "p", "q", "r", "r", "r", "r", "r", "r", "s", "s", "s", "s", "t", "t", "t", "t", 
										  "t" ,"t", "u", "u", "u", "u", "v", "v", "w", "w", "x", "y", "y", "z"];
				for(i = 0; i < 15; i++)
				{
					for(j = 0; j < 15; j++)
					{
						boardArray[i][j].stringData = boardTileArray[i][j];
						boardArray[i][j].gotoAndStop(boardSymbolArray[i][j]);
						boardArray[i][j].valLock = 0;
					}
				}
				playerScore = 0;
				computerScore = 0;
				turn = 0;
				gameMode = 1;
				readingText = 0; 
				
				for (i = 0; i < 7; i++)
				{
					randNum = Math.floor(Math.random() * (alphabetArray.length));
					currentTiles[i].stringData = alphabetArray[randNum];
					alphabetArray.splice(randNum, 1);
					currentTiles[i].gotoAndStop(currentTiles[i].stringData);
				}
				scoreBox.text = "Player: "+playerScore+"				Computer: "+computerScore;
				removeChild(infoBox);
			} // end else if gameMode = 3;
			
			
			addEventListener(MouseEvent.MOUSE_DOWN, onClick);
			startIndex = -1;
			startXIndex = -1;
			startYIndex = -1;
			pressedEnter = 0;
			pressedShuffle = 0;
			pressedSwap = 0;
		}
		
		// This is the computer's turn.
		public function computerGo():void
		{
			// Computer turns!! Only when the button is pressed. 
			// Step 1, find available starting tiles

			var totalSuccess:int = 0;
			var candidateArray:Array = [];
			
			for(var i:int = 0; i < 15; i++)
			{
				for(var j:int = 0; j < 15; j++)
				{
					if (i == 0)
					{
						if (j == 0)
						{
							if (boardTileArray[i][j] == "lo" && 
								((boardTileArray[i][j+1] == "em" && boardTileArray[i+1][j+1] == "em") || 
								 (boardTileArray[i+1][j] == "em" && boardTileArray[i+1][j+1] == "em")))
							{
								var tempArray:Array = [];
								tempArray.push(i);
								tempArray.push(j);
								candidateArray.push(tempArray);
							}
						}
						else if(j == 14)
						{
							if(boardTileArray[i][j] == "lo" && 
							   ((boardTileArray[i][j-1] == "em" && boardTileArray[i+1][j-1] == "em") || 
								(boardTileArray[i+1][j] == "em" && boardTileArray[i+1][j-1] == "em")))
							{
								tempArray = [];
								tempArray.push(i);
								tempArray.push(j);
								candidateArray.push(tempArray);
							}
						}
						else if(boardTileArray[i][j] == "lo"  && ((boardTileArray[i+1][j-1] == "em" && boardTileArray[i+1][j] == "em" && boardTileArray[i+1][j+1] == "em" && boardTileArray[i+2][j] == "em") || (boardTileArray[i][j-1] == "em" && boardTileArray[i][j+1] == "em" && boardTileArray[i+1][j-1] == "em" && boardTileArray[i+1][j+1] == "em" && (boardTileArray[i][j+2]=="em" || boardTileArray[i][j-2]=="em"))))
						{
							tempArray = [];
							tempArray.push(i);
							tempArray.push(j);
							candidateArray.push(tempArray);
						}  
					}
					else if (i == 14)
					{
						if(j == 0)
						{
							if(boardTileArray[i][j] == "lo" && ((boardTileArray[i][j+1] == "em" && boardTileArray[i-1][j+1] == "em") || (boardTileArray[i-1][j] == "em" && boardTileArray[i-1][j+1] == "em")))
							{
								tempArray = [];
								tempArray.push(i);
								tempArray.push(j);
								candidateArray.push(tempArray);
							}
						}
						else if(j == 14)
						{
							if(boardTileArray[i][j] == "lo" && ((boardTileArray[i][j-1] == "em" && boardTileArray[i-1][j-1] == "em") || (boardTileArray[i-1][j] == "em" && boardTileArray[i-1][j-1] == "em")))
							{
								tempArray = [];
								tempArray.push(i);
								tempArray.push(j);
								candidateArray.push(tempArray);
							}
						}
						else if(boardTileArray[i][j] == "lo" && ((boardTileArray[i-1][j-1] == "em" && boardTileArray[i-1][j] == "em" && boardTileArray[i-1][j+1] == "em" && boardTileArray[i-2][j] == "em") || (boardTileArray[i][j-1] == "em" && boardTileArray[i][j+1] == "em" && boardTileArray[i-1][j-1] == "em" && boardTileArray[i-1][j+1] == "em")))
						{
							tempArray = [];
							tempArray.push(i);
							tempArray.push(j);
							candidateArray.push(tempArray);
						}
					}
					else if(j == 0)
					{
						if(boardTileArray[i][j] == "lo" && ((boardTileArray[i-1][j+1] == "em" && boardTileArray[i][j+1] == "em" && boardTileArray[i+1][j+1] == "em") || (boardTileArray[i-1][j] == "em" && boardTileArray[i-1][j+1] == "em" && boardTileArray[i+1][j] == "em" && boardTileArray[i+1][j+1] == "em")))
						{
							tempArray = [];
							tempArray.push(i);
							tempArray.push(j);
							candidateArray.push(tempArray);
						}
					}
					else if(j == 14)
					{
						if(boardTileArray[i][j] == "lo" && ((boardTileArray[i-1][j-1] == "em" && boardTileArray[i][j-1] == "em" && boardTileArray[i+1][j-1] == "em") || (boardTileArray[i-1][j] == "em" && boardTileArray[i-1][j-1] == "em" && boardTileArray[i+1][j] == "em" && boardTileArray[i+1][j-1] == "em")))
						{
							tempArray = [];
							tempArray.push(i);
							tempArray.push(j);
							candidateArray.push(tempArray);
						}
					}
					else if(boardTileArray[i][j] == "lo" && ((boardTileArray[i+1][j-1] == "em" && boardTileArray[i+1][j+1] == "em" && boardTileArray[i-1][j-1] == "em" && boardTileArray[i-1][j+1] == "em" && boardTileArray[i-1][j] == "em" && boardTileArray[i+1][j] == "em") || (boardTileArray[i][j] == "lo" && boardTileArray[i+1][j-1] == "em" && boardTileArray[i+1][j+1] == "em" && boardTileArray[i-1][j-1] == "em" && boardTileArray[i-1][j+1] == "em" && boardTileArray[i][j-1] == "em" && boardTileArray[i][j+1] == "em")))
					{
						tempArray = [];
						tempArray.push(i);
						tempArray.push(j);
						candidateArray.push(tempArray);
					}
				}
			}
			
			if (candidateArray.length == 0) {
				trace("The Computer Passes");
				infoBox.text = "The Computer Passes. Click Anywhere to Continue.";
				readingText = 1;
				addChild(infoBox);
				totalSuccess = 1;
				turn++;
			}
			
			
			trace(candidateArray);
			var timesUp:int = 0;
			var startTime = getTimer();
			while(totalSuccess == 0)
			{
				if(getTimer() - startTime > 1000)
				{
					timesUp = 1;
				}
				//Let's find our word TODO use existing function
				var randWord:String;
				randWord = wordDict.random();
				trace(randWord);
				var randWordArray:Array = randWord.split("");
				var compositionCorrect = 0;
				
				if (areLettersAvailable(randWord)) {
					compositionCorrect = 1;
				}
				
				if(timesUp)
				{
					infoBox.text = "The computer passes. Click Anywhere to continue.";
					readingText = 1;
					addChild(infoBox);
					turn++;
					break;
				}
				if(compositionCorrect == 1)
				{
					//Check to see if we can even put the word on the board (does it go through one of our candidate letters
					for(i = 0; i<candidateArray.length; i++)
					{
						for(j = 0; j < randWordArray.length; j++)
						{
							if(boardArray[candidateArray[i][0]][candidateArray[i][1]].stringData == randWordArray[j])
							{
								trace("SUCCESS");
								//Now let's try to place the word and then check if it's okay. First we need to see if this is a vertical or horizontal placement
								if((candidateArray[i][1] != 0 && boardTileArray[candidateArray[i][0]][candidateArray[i][1] - 1] == "lo") ||  (candidateArray[i][1] != 14 &&boardTileArray[candidateArray[i][0]][candidateArray[i][1] + 1] == "lo"))
								{
									var adjSuccess:int = 1;
									trace("Original Word Runs Horizontal, let's go verical");
									//Original word runs horizontal, let's go vertical
									trace(candidateArray[i][0]-j,  randWordArray.length - j + candidateArray[i][0]);
									if(candidateArray[i][0]-j >= 0 && randWordArray.length - j + candidateArray[i][0] <= 15)
									{
										for(var k:int = 0; k < (randWordArray.length); k++)
										{
											if(k != j)
											{
												if(boardTileArray[k + candidateArray[i][0]-j][candidateArray[i][1]] == "em")
												{
													boardTileArray[k + candidateArray[i][0]-j][candidateArray[i][1]] = randWordArray[k];
												}	
												else if(boardTileArray[k + candidateArray[i][0]-j][candidateArray[i][1]] == "lo")
												{
													adjSuccess = 0;
													break;
												}
											}
										}
									}
									else
									{
										trace("Index out of bounds");
										break;
									}
									//Check to make sure that there's only empty spaces beside the new spaces
									for(k = 0; k < randWordArray.length; k++)
									{
										if(boardTileArray[k + candidateArray[i][0]-j][candidateArray[i][1]] != "lo")
										{
											if((candidateArray[i][1]+1 != 15 && boardTileArray[k+candidateArray[i][0]-j][candidateArray[i][1]+1] != "em") || (candidateArray[i][1]-1 != -1 && boardTileArray[k+candidateArray[i][0]-j][candidateArray[i][1]-1] != "em"))
											{
												adjSuccess = 0;
												break;
											}	
										}	
									}
									if(adjSuccess == 1)
									{
										var topSuccess:int = 1;
										var bottomSuccess:int =1;
										if(candidateArray[i][0]-j != 0 && boardTileArray[candidateArray[i][0]-j-1][candidateArray[i][1]] != "em")
										{
											topSuccess = 0;
										}
										if(candidateArray[i][0]-j+randWordArray.length != 15 && boardTileArray[candidateArray[i][0]-j+randWordArray.length][candidateArray[i][1]] != "em")
										{
											bottomSuccess = 0;
										}
										if(topSuccess == 0 || bottomSuccess == 0)
										{
											adjSuccess = 0;
										}
									
									}
									
									if(adjSuccess == 1)
									{
										//Proceed to the next check...if there are letters above or below this word
										var scoreChange:int = 0;
										var doubleWord:int = 0;
										var tripleWord:int = 0;
										for(k = 0; k < (randWordArray.length); k++)
										{
											if(boardTileArray[k + candidateArray[i][0]-j][candidateArray[i][1]] != "lo")
											{
												alphabetArray.splice(alphabetArray.indexOf(randWordArray[k]),1);
											}
											boardTileArray[k + candidateArray[i][0]-j][candidateArray[i][1]] = "lo";
											boardArray[k + candidateArray[i][0]-j][candidateArray[i][1]].stringData = randWordArray[k];
											boardArray[k + candidateArray[i][0]-j][candidateArray[i][1]].valLock = 1;
											boardArray[k + candidateArray[i][0]-j][candidateArray[i][1]].gotoAndStop(boardArray[k + candidateArray[i][0]-j][candidateArray[i][1]].stringData);
											if(boardSymbolArray[k + candidateArray[i][0]-j][candidateArray[i][1]] == "dl")
											{
												scoreChange = scoreChange + (scoreDict[boardArray[k + candidateArray[i][0]-j][candidateArray[i][1]].stringData] * 2);
											}
											else if(boardSymbolArray[k + candidateArray[i][0]-j][candidateArray[i][1]] == "tl")
											{
												scoreChange = scoreChange + (scoreDict[boardArray[k + candidateArray[i][0]-j][candidateArray[i][1]].stringData] * 3);
											}
											else if(boardSymbolArray[k + candidateArray[i][0]-j][candidateArray[i][1]] == "tw")
											{
												tripleWord = 1;
												scoreChange = scoreChange + scoreDict[boardArray[k + candidateArray[i][0]-j][candidateArray[i][1]].stringData];
											}
											else if(boardSymbolArray[k + candidateArray[i][0]-j][candidateArray[i][1]] == "dw")
											{
												doubleWord = 1;
												scoreChange = scoreChange + scoreDict[boardArray[k + candidateArray[i][0]-j][candidateArray[i][1]].stringData];
											}
											else
											{
												scoreChange = scoreChange + scoreDict[boardArray[k + candidateArray[i][0]-j][candidateArray[i][1]].stringData];
											}
											
										}
										
										if(tripleWord == 1)
										{
											computerScore = computerScore + (scoreChange * 3);
										}
										else if(doubleWord == 1)
										{
											computerScore = computerScore + (scoreChange * 2);
										}
										else
										{
											computerScore = computerScore + scoreChange;
										}
										trace("Player Score: "+playerScore);
										trace("Computer Score: "+computerScore);
										scoreBox.text = "Player: "+playerScore+"				Computer: "+computerScore;
										totalSuccess = 1;
										if(computerScore >= POINTS_TO_WIN)
										{
											gameMode = 3;
											infoBox.text = "The Computer won! Better luck next time. Click anywhere to play again!";
											addChild(infoBox);
											
											//Might as well post stuff
											variables = new URLVariables();
											variables.debug = true;
											variables.id = idArray[0];
											variables.nonce = idArray[1];
											variables.action = "submit";
											variables["data[]"] = dataArray;
											
											var request:URLRequest = new URLRequest(WWF_URL);
											request.data = variables;
											request.method = URLRequestMethod.POST;
									
											var loader:URLLoader = new URLLoader();
											loader.addEventListener(Event.COMPLETE, completeHandler);
									
											loader.load(request);	
											dataArray = [];
											
										}
										break;
									}
									else
									{
										//Revert everything!
										trace("let's try this again");
										for(k = 0; k < randWordArray.length; k++)
										{
											if(boardTileArray[k + candidateArray[i][0]-j][candidateArray[i][1]] != "lo")
											{
												boardTileArray[k + candidateArray[i][0]-j][candidateArray[i][1]] = "em";
											}
										}
									}
								}
								else if((candidateArray[i][0]!=0 && boardTileArray[candidateArray[i][0]-1][candidateArray[i][1]] == "lo") || (candidateArray[i][0] != 14 && boardTileArray[candidateArray[i][0]+1][candidateArray[i][1]] == "lo"))
								{
									adjSuccess = 1;
									trace("Original Word Vertical, let's go horizontal");
									//going to need to make sure we have space to work here eventually
									if(candidateArray[i][1]-j >= 0 && randWordArray.length - j + candidateArray[i][1] <= 15)
									{
										for(k = 0; k < randWordArray.length; k++)
										{
											if(k != j)
											{
												if(boardTileArray[candidateArray[i][0]][k + candidateArray[i][1]-j] == "em")
												{
													boardTileArray[candidateArray[i][0]][k + candidateArray[i][1] - j] = randWordArray[k];
												}
												else if(boardTileArray[candidateArray[i][0]][k + candidateArray[i][1] - j] == "lo")
												{
													adjSuccess = 0;
													break;
												}
											}
										}
									}
									else
									{
										trace("Index out of bounds");
										break;
									}
									//Check to make sure that there's only empty spaces beside the new spaces
									for(k = 0; k < randWordArray.length; k++)
									{
										if(boardTileArray[candidateArray[i][0]][k + candidateArray[i][1] - j] != "lo")
										{
											if((candidateArray[i][0]+1 != 15 && boardTileArray[candidateArray[i][0]+1][k + candidateArray[i][1] - j] != "em") || (candidateArray[i][0] - 1 != -1 && boardTileArray[candidateArray[i][0]-1][k + candidateArray[i][1] - j] != "em"))
											{
												adjSuccess = 0;
												break;
											}
										}
									}
									if(adjSuccess == 1)
									{
										topSuccess = 1;
										bottomSuccess = 1;
										trace(boardTileArray[candidateArray[i][0]][candidateArray[i][1]-j-1]);
										if(candidateArray[i][1]-j != 0 && boardTileArray[candidateArray[i][0]][candidateArray[i][1]-j-1] != "em")
										{
											topSuccess = 0; 
										}
										if(candidateArray[i][1]-j+randWordArray.length != 15 && boardTileArray[candidateArray[i][0]][candidateArray[i][1]-j+randWordArray.length] != "em")
										{
											bottomSuccess = 0; 
										}
										if(topSuccess == 0 || bottomSuccess == 0)
										{
											adjSuccess = 0;
											trace("Run off the top or bottom");
										}
									}
										
									if(adjSuccess == 1)
									{
										//Proceed to the next check, if there are letters above or below...wait...we did that above, WINNER!
										for(k = 0; k < randWordArray.length; k++)
										{
											if(boardTileArray[candidateArray[i][0]][k+candidateArray[i][1]-j] != "lo")
											{
												alphabetArray.splice(alphabetArray.indexOf(randWordArray[k]),1);
											}
											boardTileArray[candidateArray[i][0]][k+candidateArray[i][1]-j] = "lo";
											boardArray[candidateArray[i][0]][k+candidateArray[i][1]-j].stringData = randWordArray[k];
											boardArray[candidateArray[i][0]][k+candidateArray[i][1]-j].valLock = 1;
											boardArray[candidateArray[i][0]][k+candidateArray[i][1]-j].gotoAndStop(boardArray[candidateArray[i][0]][k+candidateArray[i][1]-j].stringData);
											if(boardSymbolArray[candidateArray[i][0]][k+candidateArray[i][1]-j] == "dl")
											{
												scoreChange = scoreChange + (scoreDict[boardArray[candidateArray[i][0]][k+candidateArray[i][1]-j].stringData] * 2);
											}
											else if(boardSymbolArray[candidateArray[i][0]][k+candidateArray[i][1]-1] == "tl")
											{
												scoreChange = scoreChange + (scoreDict[boardArray[candidateArray[i][0]][k+candidateArray[i][1]-j].stringData] * 3);
											}
											else if(boardSymbolArray[candidateArray[i][0]][k+candidateArray[i][1]-j] == "tw")
											{
												tripleWord = 1;
												scoreChange = scoreChange + scoreDict[boardArray[candidateArray[i][0]][k+candidateArray[i][1]-j].stringData];
											}
											else if(boardSymbolArray[candidateArray[i][0]][k+candidateArray[i][1]-j] == "dw")
											{
												doubleWord = 1;
												scoreChange = scoreChange + scoreDict[boardArray[candidateArray[i][0]][k+candidateArray[i][1]-j].stringData];
											}
											else
											{
												scoreChange = scoreChange + scoreDict[boardArray[candidateArray[i][0]][k+candidateArray[i][1]-j].stringData];
											}
											
											
										}
										if(tripleWord == 1)
										{
											computerScore = computerScore + (scoreChange * 3);
										}
										else if(doubleWord == 1)
										{
											computerScore = computerScore + (scoreChange * 2);
										}
										else
										{
											computerScore = computerScore + scoreChange;
										}
										
										trace("Player Score: "+playerScore);
										trace("Computer Score: "+computerScore);
										scoreBox.text = "Player: "+playerScore+"				Computer: "+computerScore;
										totalSuccess = 1;
										if(computerScore >= POINTS_TO_WIN)
										{
											gameMode = 3;
											infoBox.text = "The Computer won! Better luck next time. Click anywhere to play again!";
											addChild(infoBox);
											
											//Might as well post stuff
											variables = new URLVariables();
											variables.debug = true;
											variables.id = idArray[0];
											variables.nonce = idArray[1];
											variables.action = "submit";
											variables["data[]"] = dataArray;
											request = new URLRequest(WWF_URL);
											request.data = variables;
											request.method = URLRequestMethod.POST;
									
											loader = new URLLoader();
											loader.addEventListener(Event.COMPLETE, completeHandler);
									
											loader.load(request);	
											dataArray = [];
											
										}
										break;
									}
									else
									{
										trace("Let's try this again");
										//revert everything
										for(k = 0; k < randWordArray.length; k++)
										{
											if(boardTileArray[candidateArray[i][0]][k+candidateArray[i][1]-j] != "lo")
											{
												boardTileArray[candidateArray[i][0]][k+candidateArray[i][1]-j] = "em";
											}
										}
									}
								}
							}
						}
						if(totalSuccess == 1)
						{
							turn++;
							break;
	
						}
					}
				}
			}
		}
	}
}
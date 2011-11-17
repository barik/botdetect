package 
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class engine extends MovieClip
	{

		//This holds the tile objects
		public var boardArray:Array = [];
		public var holdingTile:int = 0;
		public var newLetter:letters;
		public var startIndex:int = -1;
		public var startXIndex:int = -1;
		public var startYIndex:int = -1;
		public var wordDict:wordDictionary;
		public var pressedEnter:int = 0;
		public var turn:int = 0;
		//This tells me what's originally in each square (is it triple word, double letter, or what).
		public var boardSymbolArray:Array = [
		 ["em", "em", "em", "tw", "em", "em", "tl", "em", "tl", "em", "em", "tw", "em", "em", "em"],
		 ["em", "em", "dl", "em", "em", "dw", "em", "em", "em", "dw", "em", "em", "dl", "em", "em"],
		 ["em", "dl", "em", "em", "dl", "em", "em", "em", "em", "em", "dl", "em", "em", "dl", "em"],
		 ["tw", "em", "em", "tl", "em", "em", "em", "dw", "em", "em", "em", "tl", "em", "em", "tw"],
		 ["em", "em", "dl", "em", "em", "em", "dl", "em", "dl", "em", "em", "em", "dl", "em", "em"],
		 ["em", "dw", "em", "em", "em", "tl", "em", "em", "em", "tl", "em", "em", "em", "dw", "em"],
		 ["tl", "em", "em", "em", "dl", "em", "em", "em", "em", "em", "dl", "em", "em", "em", "tl"],
		 ["em", "em", "em", "dw", "em", "em", "em", "st", "em", "em", "em", "dw", "em", "em", "em"],
		 ["tl", "em", "em", "em", "dl", "em", "em", "em", "em", "em", "dl", "em", "em", "em", "tl"],
		 ["em", "dw", "em", "em", "em", "tl", "em", "em", "em", "tl", "em", "em", "em", "dw", "em"],
		 ["em", "em", "dl", "em", "em", "em", "dl", "em", "dl", "em", "em", "em", "dl", "em", "em"],
		 ["tw", "em", "em", "tl", "em", "em", "em", "dw", "em", "em", "em", "tl", "em", "em", "tw"],
		 ["em", "dl", "em", "em", "dl", "em", "em", "em", "em", "em", "dl", "em", "em", "dl", "em"],
		 ["em", "em", "dl", "em", "em", "dw", "em", "em", "em", "dw", "em", "em", "dl", "em", "em"],
		 ["em", "em", "em", "tw", "em", "em", "tl", "em", "tl", "em", "em", "tw", "em", "em", "em"]
		];

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

		public var currentTiles:Array = [];

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


		private function init(e:Event = null):void
		{
			wordDict = new wordDictionary();
			for (var i = 0; i < 15; i++)
			{
				var tempArray:Array = [];
				for (var j = 0; j < 15; j++)
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
					boardArray[i][j].y = i * 35;
					addChild(boardArray[i][j]);
					boardArray[i][j].gotoAndStop(boardSymbolArray[i][j]);
				}
			}

			var tileFrame = new tileHolderFrame();
			tileFrame.y = 35 * 15;
			tileFrame.x = 0;
			addChild(tileFrame);

			for (i = 0; i < 7; i++)
			{

				var holdTile = new holderTile(alphabetArray[Math.floor(Math.random() * (alphabetArray.length))]);
				currentTiles.push(holdTile);
				currentTiles[i].x = 38 * i + 130;
				currentTiles[i].y = 35 * 15 + 8;
				addChild(currentTiles[i]);
				currentTiles[i].gotoAndStop(currentTiles[i].stringData);
			}

			var enterButton:button = new button();
			enterButton.x = 10;
			enterButton.y = 35 * 15 + 6;
			addChild(enterButton);
			addEventListener(Event.ENTER_FRAME, onFrameEnter);
			addEventListener(MouseEvent.MOUSE_DOWN, onClick);
		}

		public function onFrameEnter(e:Event=null):void
		{
			for (var i:int = numChildren-1; i >= 0; i--)
			{
				if (getChildAt(i) is letters)
				{
					MovieClip(getChildAt(i)).onFrameEnters();
				}
			}
		}
		function onClick(eventObject:MouseEvent)
		{

			if (mouseY >= 35*15+8 && mouseY <= 35*15+48)
			{
				var index:int = -1;
				if (mouseX >=10 && mouseX <=60)
				{
					pressedEnter = 1;
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
			}
			else if (mouseY <= 35*15)
			{
				var xIndex:int = -1;
				var yIndex:int = -1;
				for (i = 0; i < 15; i++)
				{
					if (mouseX >= 35*i && mouseX <= 35*(i+1))
					{
						xIndex = i;
					}
					if (mouseY >= 35*i && mouseY <= 35*(i+1))
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

		function onUnclick(eventObject:MouseEvent)
		{
			for (var i:int = numChildren-1; i >= 0; i--)
			{
				if (getChildAt(i) is letters)
				{
					removeChildAt(i);
					holdingTile = 0;

				}
			}
			if (newLetter != null && mouseY >= 35*15+1 && mouseY <= 35*15+48)
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
					if (currentTiles[index].stringData == "empty")
					{
						currentTiles[index].stringData = newLetter.stringData;
						currentTiles[index].gotoAndStop(currentTiles[index].stringData);
						newLetter = null;
					}
					else if (startIndex != -1)
					{
						var tempString:String = currentTiles[index].stringData;
						currentTiles[index].stringData = newLetter.stringData;
						currentTiles[index].gotoAndStop(currentTiles[index].stringData);
						currentTiles[startIndex].stringData = tempString;
						currentTiles[startIndex].gotoAndStop(currentTiles[startIndex].stringData);
						newLetter = null;
					}
					else if (startXIndex != -1 && startYIndex != -1)
					{
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
					currentTiles[startIndex].stringData = newLetter.stringData;
					currentTiles[startIndex].gotoAndStop(currentTiles[startIndex].stringData);
					newLetter = null;
				}
				else if (startXIndex != -1 && startYIndex != 1)
				{
					boardArray[startYIndex][startXIndex].stringData = newLetter.stringData;
					boardArray[startYIndex][startXIndex].gotoAndStop(boardArray[startYIndex][startXIndex].stringData);
					newLetter = null;
				}
			}
			else if (mouseY <= 35*15)
			{
				var xIndex:int = -1;
				var yIndex:int = -1;
				for (i = 0; i < 15; i++)
				{
					if (mouseX >= 35*i && mouseX <= 35*(i+1))
					{
						xIndex = i;
					}
					if (mouseY >= 35*i && mouseY <= 35*(i+1))
					{
						yIndex = i;
					}
				}

				if (xIndex != -1 && yIndex != -1)
				{
					if (newLetter != null && (boardArray[yIndex][xIndex].stringData == "em" || boardArray[yIndex][xIndex].stringData == "dw" || boardArray[yIndex][xIndex].stringData == "dl" || boardArray[yIndex][xIndex].stringData == "tw" || boardArray[yIndex][xIndex].stringData == "tl" || boardArray[yIndex][xIndex].stringData == "st"))
					{
						boardArray[yIndex][xIndex].stringData = newLetter.stringData;
						boardTileArray[yIndex][xIndex] = newLetter.stringData;
						boardArray[yIndex][xIndex].gotoAndStop(boardArray[yIndex][xIndex].stringData);
						newLetter = null;
					}
					else if (newLetter != null && !(boardArray[yIndex][xIndex].stringData == "em" || boardArray[yIndex][xIndex].stringData == "dw" || boardArray[yIndex][xIndex].stringData == "dl" || boardArray[yIndex][xIndex].stringData == "tw" || boardArray[yIndex][xIndex].stringData == "tl" || boardArray[yIndex][xIndex].stringData == "st"))
					{
						if (startIndex != -1)
						{
							currentTiles[startIndex].stringData = newLetter.stringData;
							currentTiles[startIndex].gotoAndStop(currentTiles[startIndex].stringData);
							newLetter = null;
						}
						else if (startXIndex != -1 && startYIndex != -1)
						{
							if (boardArray[yIndex][xIndex].valLock == 0)
							{
								tempString = boardArray[yIndex][xIndex].stringData;
								boardArray[yIndex][xIndex].stringData = newLetter.stringData;
								boardTileArray[yIndex][xIndex] = newLetter.stringData;
								boardArray[startYIndex][startXIndex].stringData = tempString;
								boardTileArray[startYIndex][startXIndex] = tempString;
								boardArray[startYIndex][startXIndex].gotoAndStop(boardArray[startYIndex][startXIndex].stringData);
								boardArray[yIndex][xIndex].gotoAndStop(boardArray[yIndex][xIndex].stringData);
							}
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
			else if (mouseY > 35*15+48)
			{
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
			else if (pressedEnter == 1 && mouseY >= 35*15+8 && mouseY <= 35*15+48 && mouseX >=10 && mouseX <=60)
			{
				//Go on, verify that word choice. 
				trace("Verifying Word Choice");
				if (turn == 0)
				{
					if (boardTileArray[7][7] == "em")
					{
						trace("Your Word Needs to cross the star tile");
					}
					else
					{
						var frontIndex:int = 1;
						var backIndex:int = 1;
						var wordArray:Array = [];
						var dir:String = "";
						var valid:int = 1;
						wordArray.push(boardTileArray[7][7]);
						if (boardTileArray[7][7 + 1] != "em" || boardTileArray[7][7 - 1] != "em")
						{
							dir = "horizontal";
						}
						else if (boardTileArray[7+1][7] != "em" || boardTileArray[7-1][7] != "em")
						{
							dir = "vertical";
						}
						if (dir == "horizontal")
						{
							while (boardTileArray[7][7-frontIndex] != "em" || boardTileArray[7][7+backIndex] != "em")
							{
								if (boardTileArray[7][7 - frontIndex] != "em")
								{
									wordArray.unshift(boardTileArray[7][7-frontIndex]);
									frontIndex++;
								}
								if (boardTileArray[7][7 + backIndex] != "em")
								{
									wordArray.push(boardTileArray[7][7+backIndex]);
									backIndex++;
								}
							}
							//Check for stray tiles
							frontIndex = 7 - frontIndex + 1;
							backIndex = 7 + backIndex - 1;
							for (i =0; i < 15; i++)
							{
								for (var j:int = 0; j < 15; j++)
								{
									if (i != 7 || ((i == 7 && j <frontIndex)||(i == 7 && j > backIndex)))
									{
										//trace(boardTileArray[i][j]);
										if (boardTileArray[i][j] != "em")
										{
											valid = 0;
											break;
										}
									}
								}
							}
						}
						else
						{
							while (boardTileArray[7-frontIndex][7] != "em" || boardTileArray [7+backIndex][7] != "em")
							{
								if (boardTileArray[7 - frontIndex][7] != "em")
								{
									wordArray.unshift(boardTileArray[7-frontIndex][7]);
									frontIndex++;
								}
								if (boardTileArray[7 + backIndex][7] != "em")
								{
									wordArray.push(boardTileArray[7+backIndex][7]);
									backIndex++;
								}
							}
							frontIndex = 7 - frontIndex + 1;
							backIndex = 7 + backIndex - 1;
							for (i =0; i < 15; i++)
							{
								for (j = 0; j < 15; j++)
								{
									if (j != 7 || ((j == 7 && i < frontIndex) || (j == 7 && i > backIndex)))
									{
										//trace(boardTileArray[i][j]);
										if (boardTileArray[i][j] != "em")
										{
											valid = 0;
											break;
										}
									}
								}
							}
						}

						if (valid == 1)
						{
							var word:String = wordArray.join("");
							trace(word);
							if (wordDict.contains(word))
							{
								trace("Word Accepted, Locking in place");
								for (i = frontIndex; i < backIndex+1; i++)
								{
									if (dir == "horizontal")
									{
										boardTileArray[7][i] = "lo";
										boardArray[7][i].valLock = 1;
									}
									else
									{
										boardTileArray[i][7] = "lo";
										boardArray[i][7].valLock = 1;
									}
								}

								//Also, give them more letters

								for (i = 0; i < currentTiles.length; i++)
								{
									if (currentTiles[i].stringData == "empty")
									{
										currentTiles[i].stringData = alphabetArray[Math.floor(Math.random() * (1 + 25))];
										currentTiles[i].gotoAndStop(currentTiles[i].stringData);
									}
								}
								//This is where we'd calculate score
								turn++;
							}
							else
							{
								trace(word+" is not a word");
							}
						}
						else
						{
							trace("Invalid Board Configuration");
						}
					}
				}
				else if(turn%2 == 0)
				{
					//What to do on turn 2 and beyond
					//First, we need to find where we start
					var startX:int = -1;
					var startY:int = -1;
					for (i = 0; i < 15; i++)
					{
						for (j = 0; j < 15; j++)
						{
							if (boardTileArray[i][j] != "em" && boardTileArray[i][j] != "lo")
							{
								startX = j;
								startY = i;
								break;
							}
						}
					}

					trace(startX, startY);
					//Figure out if the word runs horizontal or vertically
					if (startX == -1 && startY == -1)
					{
						trace("Place tiles noob");
					}
					else
					{
						if (boardTileArray[startY][startX + 1] != "em" || boardTileArray[startY][startX - 1] != "em")
						{
							dir = "horizontal";
						}
						else if (boardTileArray[startY+1][startX] != "em" || boardTileArray[startY-1][startX] != "em")
						{
							dir = "vertical";
						}
						else
						{
							trace("Invalid configuration!");
						}
						trace(dir);
						//Make sure it goes through at least 1 locked square
						var front:int = 1;
						var back:int = 1;
						var foundLock:int = 0;
						if (dir == "horizontal")
						{

							while (boardTileArray[startY][startX-front] != "em" || boardTileArray[startY][startX+back] != "em")
							{
								if (boardTileArray[startY][startX - front] == "lo")
								{
									foundLock = 1;
									break;
								}
								else if (boardTileArray[startY][startX+back] == "lo")
								{
									foundLock = 1;
									break;
								}
								if (boardTileArray[startY][startX - front] != "em")
								{
									front++;
								}
								if (boardTileArray[startY][startX + back] != "em")
								{
									back++;
								}
							}
							if (foundLock == 1)
							{
								trace("Good, your word goes through another one");
								//Find the word length
								front = 1;
								back = 1;
								wordArray = [];
								if (boardTileArray[startY][startX] == "lo")
								{
									trace(boardArray[startY][startX].stringData);
									wordArray.push(boardArray[startY][startX].stringData);
								}
								else
								{
									wordArray.push(boardTileArray[startY][startX]);
								}
								while (boardTileArray[startY][startX-front] != "em" || boardTileArray[startY][startX+back] != "em")
								{
									if (boardTileArray[startY][startX - front] != "em")
									{
										if (boardTileArray[startY][startX - front] == "lo")
										{
											wordArray.unshift(boardArray[startY][startX-front].stringData);
										}
										else
										{
											wordArray.unshift(boardTileArray[startY][startX-front]);
										}
										front++;
									}
									if (boardTileArray[startY][startX + back] != "em")
									{
										if (boardTileArray[startY][startX + back] == "lo")
										{
											wordArray.push(boardArray[startY][startX+back].stringData);
										}
										else
										{
											wordArray.push(boardTileArray[startY][startX+back]);
										}
										back++;
									}
								}
								front = startX - front;
								back = startX + back;
								front++;
								back--;
								trace(front,back);
								word = wordArray.join("");
								//Check the board for hanging tiles
								valid = 1;
								for (i =0; i < 15; i++)
								{
									for (j = 0; j < 15; j++)
									{
										if (i != startY || ((i == startY && j <front)||(i == startY && j > back)))
										{
											//trace(boardTileArray[i][j]);
											if (boardTileArray[i][j] != "em" && boardTileArray[i][j] != "lo")
											{
												valid = 0;
												break;
											}
										}
									}
								}

								trace(word);
								if (valid == 1)
								{
									if (wordDict.contains(word) && valid == 1)
									{
										//Check the adjacent stuff
										trace("Found Word, checking adjacent words");
										var adjacentWords:int = 1;
										for (i = front; i<= back; i++)
										{
											if (boardTileArray[startY][i] != "lo")
											{
												if (boardTileArray[startY + 1][i] != "em" || boardTileArray[startY - 1][i] != "em")
												{
													var subFront:int = 1;
													var subBack:int = 1;
													var subWord:Array = [];
													subWord.push(boardTileArray[startY][i]);
													while (boardTileArray[startY-subFront][i] != "em" || boardTileArray[startY+subBack][i] != "em")
													{
														if (boardTileArray[startY - subFront][i] == "lo")
														{
															subWord.unshift(boardArray[startY-subFront][i].stringData);
															subFront++;
														}
														if (boardTileArray[startY + subBack][i] == "lo")
														{
															subWord.push(boardArray[startY+subBack][i].stringData);
															subBack++;
														}
													}

													if (!(wordDict.contains(subWord.join(""))))
													{
														trace("Some words were not found");
														adjacentWords = 0;
														break;
													}
												}
											}
										}
										if(adjacentWords != 1)
										{
											trace("Some of your words ain't right");
										}
										else
										{
											trace("GOOD TO GO, LOCK IN AND ROLL OUT");
											turn++;
											for(i = front; i <= back; i++)
											{
												boardArray[startY][i].valLock = 1;
												boardTileArray[startY][i] = "lo";
											}
											for (i = 0; i < currentTiles.length; i++)
											{
												if (currentTiles[i].stringData == "empty")
												{
													currentTiles[i].stringData = alphabetArray[Math.floor(Math.random() * (1 + 25))];
													currentTiles[i].gotoAndStop(currentTiles[i].stringData);
												}
											}
										}
									}
									else
									{
										trace("Word not found");
									}
								}
								else
								{
									trace("Invalid Configuration");
								}
							}
							else
							{
								trace("Stop trying to cheat");
							}
						}
						else if (dir == "vertical")
						{
							while (boardTileArray[startY-front][startX] != "em" || boardTileArray[startY+back][startX] != "em")
							{
								if (boardTileArray[startY - front][startX] == "lo")
								{
									foundLock = 1;
									break;
								}
								else if (boardTileArray[startY+back][startX] == "lo")
								{
									foundLock = 1;
									break;
								}
								else if (boardTileArray[startY-front][startX] != "em")
								{
									front++;
								}
								else if (boardTileArray[startY+back][startX] != "em")
								{
									back++;
								}
							}

							if (foundLock == 1)
							{
								trace("Good, your word goes through another one!");
								//find word length
								front = 1;
								back = 1;
								wordArray = [];
								if(boardTileArray[startY][startX] == "lo")
								{
									wordArray.push(boardArray[startY][startX].stringData);
								}
								else
								{
									wordArray.push(boardTileArray[startY][startX]);
								}
								while(boardTileArray[startY-front][startX] != "em" || boardTileArray[startY+back][startX] != "em")
								{
									if(boardTileArray[startY-front][startX] != "em")
									{
										if(boardTileArray[startY-front][startX] == "lo")
										{
											wordArray.unshift(boardArray[startY-front][startX].stringData);
										}
										else
										{
											wordArray.unshift(boardTileArray[startY-front][startX]);
										}
										front++;
									}
									if(boardTileArray[startY+back][startX] != "em")
									{
										if(boardTileArray[startY+back][startX] == "lo")
										{
											wordArray.push(boardArray[startY+back][startX].stringData);
										}
										else
										{
											wordArray.push(boardTileArray[startY+back][startX]);
										}
										back++;
									}
								}
								front = startY - front;
								back = startY+back;
								front++;
								back--;
								word = wordArray.join("");
								//check the board for hanging tiles
								valid = 1;
								for(i = 0; i < 15; i++)
								{
									for(j = 0; j < 15; j++)
									{
										if(j != startX || ((j == startX && i < front) || (j == startX && i > back)))
										{
											if(boardTileArray[i][j] != "em" && boardTileArray[i][j] != "lo")
											{
												valid = 0;
												break;
											}
										}
									}
								}
								trace(word);
								if(valid == 1)
								{
									if(wordDict.contains(word))
									{
										//check the adjacent stuff
										trace("Found word, checking adjacent words");
										adjacentWords = 1;
										for(i = front; i <= back; i++)
										{
											if(boardTileArray[i][startX] != "lo" && (boardTileArray[i][startX+1] != "em" || boardTileArray[i][startX-1] != "em"))
											{
												subFront = 1;
												subBack = 1;
												subWord = [];
												subWord.push(boardTileArray[i][startX]);
												while(boardTileArray[i][startX-subFront] != "em" || boardTileArray[i][startX+subBack] != "em")
												{
													if(boardTileArray[i][startX-subFront] == "lo")
													{
														subWord.unshift(boardArray[i][startX-subFront].stringData);
														subFront++;
													}
													if(boardTileArray[i][startX+subBack] == "lo")
													{
														subWord.push(boardArray[i][startX+subBack].stringData);
														subBack++;
													}
												}
												if(!(wordDict.contains(subWord.join(""))))
												{
													trace("Some words were not found");
													adjacentWords = 0;
													break;
												}
											}
										}
									}
									if(adjacentWords != 1)
									{
										trace("Some of your words ain't right");
									}
									else
									{
										trace("GOOD TO GO, LOCK IN AND ROLL OUT");
										turn++;
										for(i = front; i <= back; i++)
										{
											boardArray[i][startX].valLock = 1;
											boardTileArray[i][startX] = "lo";
										}
										
										for (i = 0; i < currentTiles.length; i++)
										{
											if (currentTiles[i].stringData == "empty")
											{
												currentTiles[i].stringData = alphabetArray[Math.floor(Math.random() * (1 + 25))];
												currentTiles[i].gotoAndStop(currentTiles[i].stringData);
											}
										}
									}
								}
							}
							else
							{
								trace("Stop trying to cheat");
							}
						}
					}
				}
				else
				{
					//Computer turns!! Only when the button is pressed. 
					//Step 1, find available starting tiles
					var totalSuccess:int = 0;
					var candidateArray:Array = [];
					for(i = 0; i < 15; i++)
					{
						for(j = 0; j < 15; j++)
						{
							if(boardTileArray[i][j] == "lo" && boardTileArray[i+1][j-1] == "em" && boardTileArray[i+1][j+1] == "em" && boardTileArray[i-1][j-1] == "em" && boardTileArray[i-1][j+1] == "em")
							{
								var tempArray:Array = [];
								tempArray.push(i);
								tempArray.push(j);
								candidateArray.push(tempArray);
							}
						}
					}
					trace(candidateArray);
					
					while(totalSuccess == 0)
					{
						//Let's find our word
						var randWord:String;
						randWord = wordDict.random();
						trace(randWord);
						var randWordArray:Array = randWord.split("");
						//Check to see if we can even put the word on the board (does it go through one of our candidate letters
						for(i = 0; i<candidateArray.length; i++)
						{
							for(j = 0; j < randWordArray.length; j++)
							{
								if(boardArray[candidateArray[i][0]][candidateArray[i][1]].stringData == randWordArray[j])
								{
									trace("SUCCESS");
									//Now let's try to place the word and then check if it's okay. First we need to see if this is a vertical or horizontal placement
									if(boardTileArray[candidateArray[i][0]][candidateArray[i][1] - 1] == "lo" ||  boardTileArray[candidateArray[i][0]][candidateArray[i][1] + 1] == "lo")
									{
										var adjSuccess:int = 1;
										trace("Original Word Runs Horizontal");
										//Original word runs horizontal, let's go vertical
										for(var k:int = 0; k < (randWordArray.length); k++)
										{
											if(boardTileArray[k + candidateArray[i][0]-j][candidateArray[i][1]] == "em")
											{
												boardTileArray[k + candidateArray[i][0]-j][candidateArray[i][1]] = randWordArray[k];
												
											   
											}
										}
										//Check to make sure that there's only empty spaces beside the new spaces
										for(k = 0; k < randWordArray.length; k++)
										{
											if(boardTileArray[k + candidateArray[i][0]-j][candidateArray[i][1]] != "lo")
											{
												if(boardTileArray[k+candidateArray[i][0]-j][candidateArray[i][1]+1] != "em" || boardTileArray[k+candidateArray[i][0]-j][candidateArray[i][1]-1] != "em")
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
											if(candidateArray[i][0]-j+randWordArray.length != 14 && boardTileArray[candidateArray[i][0]-j+1+randWordArray.length][candidateArray[i][1]] != "em")
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
											for(k = 0; k < (randWordArray.length); k++)
											{
												boardTileArray[k + candidateArray[i][0]-j][candidateArray[i][1]] = "lo";
												boardArray[k + candidateArray[i][0]-j][candidateArray[i][1]].stringData = randWordArray[k];
												boardArray[k + candidateArray[i][0]-j][candidateArray[i][1]].valLock = 1;
												boardArray[k + candidateArray[i][0]-j][candidateArray[i][1]].gotoAndStop(boardArray[k + candidateArray[i][0]-j][candidateArray[i][1]].stringData);
											}
											
											totalSuccess = 1;
											break;
										}
										else
										{
											//Revert everything!
											for(k = 0; k < randWordArray.length; k++)
											{
												if(boardTileArray[k + candidateArray[i][0]-j][candidateArray[i][1]] != "lo")
												{
													boardTileArray[k + candidateArray[i][0]-j][candidateArray[i][1]] = "em";
												}
											}
										}
									}
									else if(boardTileArray[candidateArray[i][0]-1][candidateArray[i][1]] == "lo" || boardTileArray[candidateArray[i][0]+1][candidateArray[i][1]] == "lo")
									{
										trace("Original Word Vertical, let's go horizontal");
										//going to need to make sure we have space to work here eventually
										for(k = 0; k < randWordArray.length; k++)
										{
											if(boardTileArray[candidateArray[i][0]][k + candidateArray[i][1]-j] == "em")
											{
												boardTileArray[candidateArray[i][0]][k + candidateArray[i][1] - j] = randWordArray[k];
											}
										}
										
										//Check to make sure that there's only empty spaces beside the new spaces
										for(k = 0; k < randWordArray.length; k++)
										{
											if(boardTileArray[candidateArray[i][0]][k + candidateArray[i][1] - j] != "lo")
											{
												if(boardTileArray[candidateArray[i][0]+1][k + candidateArray[i][1] - j] != "em" || boardTileArray[candidateArray[i][0]-1][k + candidateArray[i][1] - j] != "em")
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
											if(candidateArray[i][0]-j != 0 && boardTileArray[candidateArray[i][0]][candidateArray[i][1]-j-1] != "em")
											{
												topSuccess = 0; 
											}
											if(candidateArray[i][0]-j+randWordArray.length != 14 && boardTileArray[candidateArray[i][0]][candidateArray[i][1]-j+1+randWordArray.length] != "em")
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
											//Proceed to the next check, if there are letters above or below...wait...we did that above, WINNER!
											for(k = 0; k < randWordArray.length; k++)
											{
												boardTileArray[candidateArray[i][0]][k+candidateArray[i][1]-j] = "lo";
												boardArray[candidateArray[i][0]][k+candidateArray[i][1]-j].stringData = randWordArray[k];
												boardArray[candidateArray[i][0]][k+candidateArray[i][1]-j].valLock = 1;
												boardArray[candidateArray[i][0]][k+candidateArray[i][1]-j].gotoAndStop(boardArray[candidateArray[i][0]][k+candidateArray[i][1]-j].stringData);
											}
										}
										else
										{
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
								break;
							}
						}
						turn++;
					}
				}

			}

			addEventListener(MouseEvent.MOUSE_DOWN, onClick);
			startIndex = -1;
			startXIndex = -1;
			startYIndex = -1;
			pressedEnter = 0;
		}
	}
}
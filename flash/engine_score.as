﻿package 
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

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
		public var pressedShuffle:int = 0;
		public var pressedSwap:int = 0;
		public var pressedPass:int = 0;
		public var turn:int = 0;
		public var playerScore:int = 0;
		public var computerScore:int = 0;
		
		
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

		public var scoreDict:Object = {"a":1, "b":4, "c":4, "d":2, "e":1, "f":4, "g":3, "h":3, "i":1, "j":10, "k":5, "l":2, "m":4,
										"n":2, "o":1, "p":4, "q":10, "r":1, "s":1, "t":1, "u":2, "v":5, "w":4, "x":8, "y":3, "z":10};


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

			var enterButton:button = new button("more");
			enterButton.x = 10;
			enterButton.y = 35 * 15 + 6;
			addChild(enterButton);
			var shuffleButton:button = new button("shuffle");
			shuffleButton.x = 68;
			shuffleButton.y = 35*15+6;
			addChild(shuffleButton);
			var swapButton:button = new button("swap");
			swapButton.x = 408;
			swapButton.y = 35*15+6
			addChild(swapButton);
			var passButton:button = new button("pass");
			passButton.x = 466;
			passButton.y = 35*15+6;
			addChild(passButton);
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
				else if(mouseX >= 68 && mouseX <= 117)
				{
					pressedShuffle = 1;
					removeEventListener(MouseEvent.MOUSE_DOWN, onClick);
					addEventListener(MouseEvent.MOUSE_UP, onUnclick);
				}
				else if(mouseX >= 408 && mouseX <= 458)
				{
					pressedSwap = 1;
					removeEventListener(MouseEvent.MOUSE_DOWN, onClick);
					addEventListener(MouseEvent.MOUSE_UP, onUnclick);
				}
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
			else if (pressedShuffle == 1 && mouseY >=35*15+8 && mouseY <= 35*15+48 && mouseX >= 68 && mouseX <=117)
			{
				//Shuffle your letters
				var permutationArray:Array = [];
				for(i = 0; i < 7; i++)
				{
					permutationArray.push(i);
				}
				for(i = 0; i < 7; i++)
				{
					var randIndex:int = Math.floor(Math.random() * 7);
					//swap i with randIndex
					tempString = currentTiles[i].stringData;
					currentTiles[i].stringData = currentTiles[randIndex].stringData;
					currentTiles[randIndex].stringData = tempString;
					currentTiles[i].gotoAndStop(currentTiles[i].stringData);
					currentTiles[randIndex].gotoAndStop(currentTiles[randIndex].stringData);
				}
			}
			else if (pressedSwap == 1 && mouseY >= 35*15+8 && mouseY <= 35*15+48 && mouseX >= 408 && mouseX <= 458)
			{
				//load up our swap thing and probably set a swapping tiles flag that will negate a LOT of things
				var swapBar:swapFrame = new swapFrame();
				swapBar.x = 64
				swapBar.y = (35*15)-55;
				addChild(swapBar);
				//Create some buttons
				var swapEnter:button = new button("more");
				swapEnter.x = 68;
				swapEnter.y = (35*15)-49;
				addChild(swapEnter);
				var swapCancel:button = new button("pass");
			}
			else if(pressedPass == 1 && mouseY>= 35*15+8 && mouseY <= 35*15+48 && mouseX >= 466 && mouseX <= 516)
			{
				turn++;
				//First, check to see if there are any stray tiles on the board. If so, get rid of those guys. 
				for(i = 0; i < 15; i++)
				{
					for(j = 0; j < 15; j++)
					{
						if(boardArray[i][j].valLock != 1)
						{
							for(var k:int = 0; k < 7; k++)
							{
								if(currentTiles[k].stringData == "empty")
								{
									currentTiles[k].stringData = boardArray[i][j].stringData;
									currentTiles[k].gotoAndStop(currentTiles[k].stringData);
									boardArray[i][j].stringData = boardTileArray[i][j];
									boardArray[i][j].gotoAndStop(boardArray[i][j].stringData);
								}
							}
						}
					}
				}
				
				//Next have the computer take it's turn, IF it's the first turn, just lay a tile on the star horizontally
				if(turn == 1)
				{
					var randWord:String;
					randWord = wordDict.random();
					var randWordArray:Array = randWord.split("");
					var scoreChange:int = 0;
					var doubleWord:int = 0; 
					for(i = 0; i < randWordArray.length; i++)
					{
						boardArray[7][i+7].stringData = randWordArray[i];
						boardArray[7][i+7].valLock = 1;
						boardArray[7][i+7].gotoAndStop(boardArray[7][i+7].stringData);
						if(boardSymbolArray[7][i+7] == "dw")
						{
							doubleWord++;
							scoreChange = scoreChange + scoreDict[boardArray[7][i+7].stringData];
							boardSymbolArray[7][7+i] = "em";
							boardTileArray[7][7+i] = "lo";
						}
						else
						{
							scoreChange = scoreChange + scoreDict[boardArray[7][i+7].stringData];
							boardSymbolArray[7][7+i] = "em";
							boardTileArray[7][7+i] = "lo";
						}
					}
					if(doubleWord != 0)
					{
						computerScore = computerScore + scoreChange*(2*doubleWord);
					}
					else
					{
						computerScore = computerScore + scoreChange;
					}
					trace("Player Score: "+playerScore);
					trace("Computer Score: "+computerScore);
				}
				else
				{
					computerGo();
				}
			}
			else if (pressedEnter == 1 && mouseY >= 35*15+8 && mouseY <= 35*15+48 && mouseX >=10 && mouseX <=60)
			{
				//Go on, verify that word choice. 
				trace("Verifying Word Choice");
				trace("Turn"+turn);
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
								if(dir == "horizontal")
								{
									scoreChange = 0;
									doubleWord = 0;
									var currentIndex:int = frontIndex;
									while(boardTileArray[7][currentIndex] != "em")
									{
										if(boardSymbolArray[7][currentIndex] == "dw")
										{
											scoreChange = scoreChange + scoreDict[boardArray[7][currentIndex].stringData];
											boardSymbolArray[7][currentIndex] = "em";
											doubleWord++;
										}
										else
										{
											scoreChange = scoreChange + scoreDict[boardArray[7][currentIndex].stringData];
										}
										currentIndex++;
									}
									if(doubleWord != 0)
									{
										playerScore = playerScore + scoreChange*(2*doubleWord);
									}
									else
									{
										playerScore = playerScore + scoreChange;
									}
								}
								else if(dir == "vertical")
								{
									currentIndex = frontIndex;
									scoreChange = 0;
									doubleWord = 0;
									while(boardTileArray[currentIndex][7] != "em")
									{
										if(boardSymbolArray[currentIndex][7] == "dw")
										{
											scoreChange = scoreChange + scoreDict[boardArray[currentIndex][7].stringData];
											boardSymbolArray[currentIndex][7] = "em";
											doubleWord++;
										}
										else
										{
											scoreChange = scoreChange + scoreDict[boardArray[currentIndex][7].stringData];
										}
										currentIndex++;
									}
									if(doubleWord != 0)
									{
										playerScore = playerScore + scoreChange*(2*doubleWord);
									}
									else
									{
										playerScore = playerScore + scoreChange;
									}
								}
								trace("Player Score: "+playerScore);
								trace("Computer Score: "+computerScore);
								turn++;
								computerGo();
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
						if ((startX != 14 && boardTileArray[startY][startX + 1] != "em") || (startX != 0 && boardTileArray[startY][startX - 1] != "em"))
						{
							dir = "horizontal";
						}
						else if ((startY != 14 && boardTileArray[startY+1][startX] != "em") || (startY != 0 && boardTileArray[startY-1][startX] != "em"))
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
							while ((startX-front >= 0 && boardTileArray[startY][startX-front] != "em") || (startX+back <= 14 && boardTileArray[startY][startX+back] != "em"))
							{
								if(startX - front >= 0)
								{
									if (boardTileArray[startY][startX - front] == "lo")
									{
										foundLock = 1;
										break;
									}
									if (boardTileArray[startY][startX - front] != "em")
									{
										front++;
									}
								}
								if(startX+back <= 14)
								{
									if (boardTileArray[startY][startX+back] == "lo")
									{
										foundLock = 1;
										break;
									}
									if (boardTileArray[startY][startX + back] != "em")
									{
										back++;
									}
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
								while ((startX - front >= 0 && boardTileArray[startY][startX-front] != "em") || (startX+back <= 14 && boardTileArray[startY][startX+back] != "em"))
								{
									if (startX-front >= 0 && boardTileArray[startY][startX - front] != "em")
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
									if (startX + back <= 14 && boardTileArray[startY][startX + back] != "em")
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
												if ((startY < 14 && boardTileArray[startY + 1][i] != "em") || (startY > 0 && boardTileArray[startY - 1][i] != "em"))
												{
													var subFront:int = 1;
													var subBack:int = 1;
													var subWord:Array = [];
													subWord.push(boardTileArray[startY][i]);
													while (boardTileArray[startY-subFront][i] != "em" || boardTileArray[startY+subBack][i] != "em")
													{
														if (startY - subFront >= 0 && boardTileArray[startY - subFront][i] == "lo")
														{
															subWord.unshift(boardArray[startY-subFront][i].stringData);
															subFront++;
														}
														if (startY + subBack <= 14 && boardTileArray[startY + subBack][i] == "lo")
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
											//Check adjacent words FIRST
											for(i = front; i < back; i++)
											{
												scoreChange = 0;
												doubleWord = 0;
												tripleWord  = 0; 
												if(boardTileArray[startY][i] != "lo")
												{
													if ((startY < 14 && boardTileArray[startY + 1][i] != "em") || (startY > 0 && boardTileArray[startY - 1][i] != "em"))
													{
														subFront = 1;
														subBack = 1;
														if(boardSymbolArray[startY][i] == "dl")
														{
															scoreChange = scoreChange + scoreDict[boardTileArray[startY][i].stringData]*2;
														}
														else if(boardSymbolArray[startY][i] == "tl")
														{
															scoreChange = scoreChange + scoreDict[boardTileArray[startY][i].stringdata]*3;
														}
														else if(boardSymbolArray[startY][i] == "dw")
														{
															scoreChange = scoreChange + scoreDict[boardTileArray[startY][i].stringData];
															doubleWord++;
														}
														else if(boardSymbolArray[startY][i] == "tw")
														{
															scoreChange = scoreChange + scoreDict[boardTileArray[startY][i].stringData];
															tripleWord++;
														}
														while (boardTileArray[startY-subFront][i] != "em" || boardTileArray[startY+subBack][i] != "em")
														{
															if (startY - subFront >= 0 && boardTileArray[startY - subFront][i] == "lo")
															{
																scoreChange = scoreChange + scoreDict[boardTileArray[startY][i].stringData];
																subFront++;
															}
															if (startY + subBack <= 14 && boardTileArray[startY + subBack][i] == "lo")
															{
																scoreChange = scoreChange + scoreDict[boardTileArray[startY][i].stringData];
																subBack++;
															}
														}
														if(doubleWord != 0)
														{
															playerScore = playerScore + scoreChange*(2*doubleWord);
														}
														else if (tripleWord != 0)
														{
															playerScore = playerScore + scoreChange*(3*tripleWord);
														}
														else
														{
															playerScore = playerScore + scoreChange;
														}
													}
												}
											}
											scoreChange = 0;
											doubleWord = 0;
											var tripleWord:int = 0; 
											for(i = front; i <= back; i++)
											{
												boardArray[startY][i].valLock = 1;
												boardTileArray[startY][i] = "lo";
												if(boardSymbolArray[startY][i] == "tl")
												{
													scoreChange = scoreChange + (scoreDict[boardArray[startY][i].stringData] * 3);
												}
												else if(boardSymbolArray[startY][i] == "dl")
												{
													scoreChange = scoreChange + (scoreDict[boardArray[startY][i].stringData] * 2);
												}
												else if(boardSymbolArray[startY][i] == "tw")
												{
													scoreChange = scoreChange + scoreDict[boardArray[startY][i].stringData];
													tripleWord++;  
												}
												else if(boardSymbolArray[startY][i] == "dw")
												{
													scoreChange = scoreChange + scoreDict[boardArray[startY][i].stringData];
													doubleWord++;
												}
												else
												{
													scoreChange = scoreChange + scoreDict[boardArray[startY][i].stringData];
												}
												boardSymbolArray[startY][i] = "em";
											}
										
											if(tripleWord != 0)
											{
												playerScore = playerScore + (scoreChange*(3*tripleWord));
											}
											else if(doubleWord != 0)
											{
												playerScore = playerScore + (scoreChange*(2*doubleWord));
											}
											else
											{
												playerScore = playerScore + scoreChange;
											}	


											//Calculate score change due to adjacent words
											for (i = 0; i < currentTiles.length; i++)
											{
												if (currentTiles[i].stringData == "empty")
												{
													currentTiles[i].stringData = alphabetArray[Math.floor(Math.random() * (1 + 25))];
													currentTiles[i].gotoAndStop(currentTiles[i].stringData);
												}
											}
											computerGo();
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
							while ((startY - front >= 0 && boardTileArray[startY-front][startX] != "em") || (startY + back <= 14 && boardTileArray[startY+back][startX] != "em"))
							{
								if(startY - front >= 0)
								{
									if (boardTileArray[startY - front][startX] == "lo")
									{
										foundLock = 1;
										break;
									}
									if (boardTileArray[startY-front][startX] != "em")
									{
										front++;
									}
								}
								if(startY + front <= 14)
								{
									if (boardTileArray[startY+back][startX] == "lo")
									{
										foundLock = 1;
										break;
									}
								
									if (boardTileArray[startY+back][startX] != "em")
									{
										back++;
									}
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
								while((startY-front >= 0 && boardTileArray[startY-front][startX] != "em") || (startY+back <= 14 && boardTileArray[startY+back][startX] != "em"))
								{
									if(startY - front >= 0 && boardTileArray[startY-front][startX] != "em")
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
									if(startY + back <= 14 && boardTileArray[startY+back][startX] != "em")
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
											if(boardTileArray[i][startX] != "lo" && ((startX < 14 && boardTileArray[i][startX+1] != "em") || (startX > 0 && boardTileArray[i][startX-1] != "em")))
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
										scoreChange = 0;
										doubleWord = 0;
										tripleWord = 0; 
										for(i = front; i <= back; i++)
										{
											boardArray[i][startX].valLock = 1;
											boardTileArray[i][startX] = "lo";
											trace(scoreDict[boardArray[i][startX].stringData]);
											if(boardSymbolArray[i][startX] == "tl")
											{
												scoreChange = scoreChange + (scoreDict[boardArray[i][startX].stringData] * 3);
											}
											else if(boardSymbolArray[i][startX] == "dl")
											{
												scoreChange = scoreChange + (scoreDict[boardArray[i][startX].stringData] * 2);
											}
											else if(boardSymbolArray[i][startX] == "tw")
											{
												scoreChange = scoreChange + scoreDict[boardArray[i][startX].stringData];
												tripleWord++;  
											}
											else if(boardSymbolArray[i][startX] == "dw")
											{
												scoreChange = scoreChange + scoreDict[boardArray[i][startX].stringData];
												doubleWord++;
											}
											else
											{
												scoreChange = scoreChange + scoreDict[boardArray[i][startX].stringData];
											}
											boardSymbolArray[i][startX] = "em";
										}
										
										if(tripleWord != 0)
										{
											playerScore = playerScore + (scoreChange*(3*tripleWord));
										}
										else if(doubleWord != 0)
										{
											playerScore = playerScore + (scoreChange*(2*doubleWord));
										}
										else
										{
											playerScore = playerScore + scoreChange;
										}
										
										
										
										//Calculate score change due to adjacent words
										
										for (i = 0; i < currentTiles.length; i++)
										{
											if (currentTiles[i].stringData == "empty")
											{
												currentTiles[i].stringData = alphabetArray[Math.floor(Math.random() * (1 + 25))];
												currentTiles[i].gotoAndStop(currentTiles[i].stringData);
											}
										}
										computerGo();
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
				

			}

			addEventListener(MouseEvent.MOUSE_DOWN, onClick);
			startIndex = -1;
			startXIndex = -1;
			startYIndex = -1;
			pressedEnter = 0;
			pressedShuffle = 0;
			pressedSwap = 0;
		}
		
		public function computerGo():void
		{
			//Computer turns!! Only when the button is pressed. 
			//Step 1, find available starting tiles
			var totalSuccess:int = 0;
			var candidateArray:Array = [];
			for(var i:int = 0; i < 15; i++)
			{
				for(var j:int = 0; j < 15; j++)
				{
					if(i == 0)
					{
						if(j == 0)
						{
							if(boardTileArray[i][j] == "lo" && ((boardTileArray[i][j+1] == "em" && boardTileArray[i+1][j+1] == "em") || (boardTileArray[i+1][j] == "em" && boardTileArray[i+1][j+1] == "em")))
							{
								var tempArray:Array = [];
								tempArray.push(i);
								tempArray.push(j);
								candidateArray.push(tempArray);
							}
						}
						else if(j == 14)
						{
							if(boardTileArray[i][j] == "lo" && ((boardTileArray[i][j-1] == "em" && boardTileArray[i+1][j-1] == "em") || (boardTileArray[i+1][j] == "em" && boardTileArray[i+1][j-1] == "em")))
							{
								tempArray = [];
								tempArray.push(i);
								tempArray.push(j);
								candidateArray.push(tempArray);
							}
						}
						else if(boardTileArray[i][j] == "lo" && ((boardTileArray[i+1][j-1] == "em" && boardTileArray[i+1][j] == "em" && boardTileArray[i+1][j+1] == "em") || (boardTileArray[i][j-1] == "em" && boardTileArray[i][j+1] == "em" && boardTileArray[i+1][j-1] == "em" && boardTileArray[i+1][j+1] == "em")))
						{
							tempArray = [];
							tempArray.push(i);
							tempArray.push(j);
							candidateArray.push(tempArray);
						}  
					}
					else if(i == 14)
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
						else if(boardTileArray[i][j] == "lo" && ((boardTileArray[i-1][j-1] == "em" && boardTileArray[i-1][j] == "em" && boardTileArray[i-1][j+1] == "em") || (boardTileArray[i][j-1] == "em" && boardTileArray[i][j+1] == "em" && boardTileArray[i-1][j-1] == "em" && boardTileArray[i-1][j+1] == "em")))
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
			if(candidateArray.length == 0)
			{
				trace("The Computer Passes");
				totalSuccess = 1;
				turn++;
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
							//BUG AFTER HERE
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
									totalSuccess = 1;
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
									totalSuccess = 1;
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
package {
	import flash.utils.ByteArray;

	public class wordDictionary extends ByteArray {
		
		[Embed(source = "enable1.txt",mimeType = "application/octet-stream")]
		private static const ScrabbleFile:Class;
		
		private static var words:Array = new ScrabbleFile().toString().split("\n");

		public function contains(word:String):Boolean {
			return words.indexOf(word.toLowerCase()) > -1;
		}
		
		public function dictionarySize():int {
			return words.length;
		}
		
		public function getWordAt(position:int):String {
			return words[position];
		}
		
		public function random():String {
			
			var tempString:String;
			
			while (true) {
								
				/* Pick a random word out of the dictionary. */
				tempString = words[Math.floor(Math.random() * words.length)];
				
				/* Use it only if the word is 5 characters or less. */
				if (tempString.length <= 5) {
					break;
				}
			}
			
			return tempString;
		}
	}
}
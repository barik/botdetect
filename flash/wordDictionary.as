package {
	import flash.utils.ByteArray;
	public class wordDictionary extends ByteArray {
		[Embed(source="f-16.txt",mimeType="application/octet-stream")]
		private static const ScrabbleFile:Class;
		private static var words:Array = new ScrabbleFile().toString().split("\n");
		public function ScrabbleDictionary() {
		}
		public function contains(word:String):Boolean {
			return words.indexOf(word.toLowerCase()) > -1;
		}
		public function random():String {
			var found:int = 0;
			var tempString:String = "";
			while(found == 0)
			{
				tempString = words[Math.floor(Math.random() * words.length)];
			
				if(tempString.split("").length <= 5)
				{
					found = 1;
				}
			}
			return tempString;
		}
	}
}
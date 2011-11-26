package  {
	
	public class WordLine {
		
		public var startX:int;
		public var startY:int;
		public var endX:int;
		public var endY:int;
		public var word:String;

		public function WordLine(startX:int, startY:int, endX:int, endY:int, word:String) {
			this.startX = startX;
			this.endX = endX;
			
			this.startY = startY;			
			this.endY = endY;
			
			this.word = word;
		}

	}
	
}

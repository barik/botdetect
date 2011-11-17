package {
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	
	public class letters extends MovieClip
	{
		public var stringData:String;
		public var velocity = 5;
		public var acceleration = 1;
		public function letters(stringData:String):void
		{
			this.stringData = stringData;
		}
		
		public function onFrameEnters():void
		{
			if(mouseX > 25)
			{
				x = x+(mouseX-25);
			}
			else if(mouseX < 25)
			{
				x = x + (mouseX-25);
			}
			if(mouseY > 10)
			{
				y = y + (mouseY-10);
			}
			else if(mouseY < 10)
			{
				y = y + (mouseY-10);
			}
		}
	}
}
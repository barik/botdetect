package {
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	
	public class tiles extends MovieClip
	{
		public var stringData:String;
		public var valLock:int = 0;
		public function tiles(stringData:String):void
		{
			this.stringData = stringData;
		}
	}
}
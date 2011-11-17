package {
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	
	public class holderTile extends MovieClip
	{
		public var stringData:String;
		public function holderTile(stringData:String):void
		{
			this.stringData = stringData;
		}
	}
}
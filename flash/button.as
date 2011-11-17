package {
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	
	public class button extends MovieClip
	{

		public function button(frame:String):void
		{
			this.gotoAndStop(frame);
		}
	}
}
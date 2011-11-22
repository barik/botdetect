package {

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.net.*;

	public class ServerTest extends MovieClip {
		
		public static const WWF_URL:String = 
			"http://ciigar.csc.ncsu.edu/tbarik/wwf/wwf.php";

		public function ServerTest() {

			var aButton:BlackButton = new BlackButton();
			aButton.x = 100;
			aButton.y = 100;

			aButton.addEventListener(MouseEvent.CLICK, onButtonClick);

			addChild(aButton);

		}

		/**
		 * See the ActionScript 3.0 Developer's Guide for Networking information:
		 * http://help.adobe.com/en_US/flash/cs/using/index.html
		 */
		public function onButtonClick(event:MouseEvent) {
						
			var variables:URLVariables = new URLVariables();
			
			/* Populate POST data. Note that arrays are handled a little differently. */
			/* debug must be set; otherwise, the remote server will not output debug data. */
			variables.debug = true;
			variables.name = "Foo";
			variables["clickdata[]"] = new Array(7, 11, 13, 15, 19, 22);
			
			var request:URLRequest = new URLRequest(WWF_URL);
			request.data = variables;
			request.method = URLRequestMethod.POST;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, completeHandler);
			
			loader.load(request);			
		}
		
		public function completeHandler(event:Event) {
			trace("Result: ");
			trace(event.target.data);
		}
	}

}
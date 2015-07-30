package netEvent
{
	import flash.events.Event;
	
	public class MessageEvent extends Event
	{
		private var _data:Object;
		public function MessageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			//TODO: implement function
			super(type, bubbles, cancelable);
		}

		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}

	}
}
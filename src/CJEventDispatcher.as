package
{
	import flash.events.EventDispatcher;

	/**
	 * 全局性 事件派发，监听
	 * @author yongjun
	 * 
	 */
	public class CJEventDispatcher extends EventDispatcher
	{
		private static var  _instance:CJEventDispatcher;
		public function CJEventDispatcher()
		{
		}
		public  static  function get o():CJEventDispatcher
		{
			if(_instance == null)
			{
				_instance = new CJEventDispatcher;
			}
			return _instance;
		}
		
		
		public function addListener(type:String,func:Function):void
		{
			if(this.hasEventListener(type))return;
			this.addEventListener(type,func);
		}
		public function removeListener(type:String,func:Function):void
		{
			this.removeEventListener(type,func);
		}
		
	}
}
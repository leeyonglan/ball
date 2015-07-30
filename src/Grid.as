package
{
	
	import engine_starling.display.SLayer;
	
	import starling.display.Quad;
	
	public class Grid extends SLayer
	{
		private var w:Number = 10;
		private var _id:Number;
		public function Grid(id:Number)
		{
			super();
			_id = id;
		}
		override protected function initialize():void
		{
			var q:Quad = new Quad(w,w,0xff0000);
			this.addChild(q);
		}
	}
}
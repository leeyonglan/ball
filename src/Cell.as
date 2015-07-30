package
{
	import flash.geom.Rectangle;
	
	public class Cell extends Rectangle
	{
		private var _id:int
		private var _gids:Array = new Array; //此格子里的物品id
		private var _gx:Number; //gid x 偏移值
		private var _gy:Number  //gid y 偏移值
		private var _globalx:Number
		private var _globaly:Number
		public function Cell(id:int,x:Number=0, y:Number=0, width:Number=0, height:Number=0)
		{
			this._id = id;
			super(x, y, width, height);
		}
		public function addGid(id:String):void
		{
			if(this._gids.indexOf(id) == -1)
			{
				this._gids.push(id);
			}
		}
		public function deleteGid(id:String):void
		{
			var pos:int = this._gids.indexOf(id);	
			if(pos != -1)
			{
				delete this._gids[pos]
			}
		}
		public function getGid():Array
		{
			return this._gids;
		}

		public function get gx():Number
		{
			return _gx;
		}

		public function set gx(value:Number):void
		{
			_gx = value;
		}

		public function get gy():Number
		{
			return _gy;
		}

		public function set gy(value:Number):void
		{
			_gy = value;
		}

		public function get globalx():Number
		{
			return _globalx;
		}

		public function set globalx(value:Number):void
		{
			_globalx = value;
		}

		public function get globaly():Number
		{
			return _globaly;
		}

		public function set globaly(value:Number):void
		{
			_globaly = value;
		}

		
	}
}
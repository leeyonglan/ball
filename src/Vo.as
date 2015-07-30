package
{
	public class Vo
	{
		private var _id:String
		private var _bgridId:int;
		private var _cgridId:int;
		public function Vo(id:String)
		{
			_id = id;
		}

		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
		}

		public function get bgridId():int
		{
			return _bgridId;
		}

		public function set bgridId(value:int):void
		{
			_bgridId = value;
		}

		public function get cgridId():int
		{
			return _cgridId;
		}

		public function set cgridId(value:int):void
		{
			_cgridId = value;
		}


	}
}
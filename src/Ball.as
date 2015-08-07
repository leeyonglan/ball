package
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class Ball extends Sprite implements Ienterframe
	{
		private var _r:Number = 10;
		private var _id:String;
		private var _name:TextField;
		private var _nameText:String;
		private var _speed:Number = 50;
		private var _score:int = 0;
		private var _graphic:Graphics;
		private var _mx:Number;
		private var _my:Number;
		private var _isplayer:Boolean = false;
		public function Ball(id:String)
		{
			super();
			this.addEventListener(Event.ADDED,function(e:Event):void
			{
				dispatchEvent(new Event("balladded",true));
			});
			this.addEventListener(Event.REMOVED,function(e:Event):void
			{
				dispatchEvent(new Event("ballremoved",true));
			});
			_id = id;
			initialize();
			this.cacheAsBitmap = true;
		}
		private function initialize():void
		{
			this._init();
		}
		private function _init():void
		{
			var sp:Sprite = new Sprite;
			var color:uint = Math.random() * 0xFFFFFF
			_graphic = sp.graphics;
			with(_graphic)
			{
				beginFill(color);
				drawCircle(0,0,this._r);
				endFill();
			}
			this.addChild(sp);
			this._name = new TextField;
			this._name.x = (-this._name.textWidth) >>1;
			this._name.y = (-this._name.textHeight) >>1;
			this.addChild(this._name);
		}
		
		private function redraw():void
		{
			var color:uint = Math.random() * 0xFFFFFF
			with(_graphic)
			{
				beginFill(color);
				drawCircle(0,0,this._r);
				endFill();
			}
			this._name.x = (-this._name.textWidth) >>1;
			this._name.y = (-this._name.textHeight) >>1;
		}
		public function set radius(r:Number):void
		{
			this._r = r;
			this._graphic.clear();
			this.redraw();
			(this.parent as CJPlayerSceneLayer).sortPlayer();
		}
		
		public function get radius():Number
		{
			return this._r;
		}
		public function set id(id:String):void
		{
			this._id = id;
		}
		public function get id():String
		{
			return this._id;
		}
		public function set bname(n:String):void
		{
			this._name.text = n;
			this._name.width = this._name.textWidth;
			this._name.height = this._name.textHeight;
		}
		public function get bname():String
		{
			return this._nameText;
		}
		
		public function set score(c:int):void
		{
			this._score = c;
		}
		public function get score():int
		{
			return this._score;
		}		
		public function setToPosition(destPoint:Point):void
		{
			x = destPoint.x;
			y = destPoint.y;
		}
		override public function set x(value:Number):void
		{
			if(super.x == value)
				return;
			super.x = value;
		}
		
		override public function set y(value:Number):void
		{
			if(super.y == value)
				return;
			super.y = value;
		}
		
		public function runTo(destPoint:Point,finish:Function = null):void
		{
			_mx = int(destPoint.x);
			_my = int(destPoint.y);
		}
		
		public function update():void
		{
			if(x == _mx && y == _my)
			{
				return;
			}
			var vecsrc:Vector2D = new Vector2D(x,y);
			var vecdest:Vector2D = new Vector2D(_mx,_my);
			var distance:Number =  vecdest.dist(vecsrc);
			var time:Number = distance / speed;
			
			var detax:Number =  _mx-x/time;
			var detay:Number = _my-y/time;
			x += detax;
			y += detay;
		}
		
		public function get speed():Number
		{
			return _speed;
		}
		public function set speed(s:Number):void
		{
			_speed = s;
		}
		
		public function toBigger(score:int):void
		{
			this.radius = this._r + (score)/30;
		}
		/**
		 * 显示升级动画
		 */
		public function showUplevelAnims():void
		{
			
		}

		public function get isplayer():Boolean
		{
			return _isplayer;
		}

		public function set isplayer(value:Boolean):void
		{
			_isplayer = value;
		}


	}
}
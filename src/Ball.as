package
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import gs.TweenMax;
	
	public class Ball extends Sprite
	{
		private var _r:Number = 5;
		private var _id:String;
		private var _name:TextField;
		private var _nameText:String;
		private var _speed:Number = 50;
		private var _score:int = 0;
		private var _graphic:Graphics;
		public function Ball(id:String)
		{
			super();
			_id = id;
			initialize();
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
				drawCircle(this._r,this._r,this._r);
				endFill();
			}
			this.addChild(sp);
			this._name = new TextField;
			this._name.x = (this._r * 2 - this._name.textWidth) >>1;
			this._name.y = (this._r * 2 - this._name.textHeight) >>1;
			this.addChild(this._name);
		}
		
		private function redraw():void
		{
			var color:uint = Math.random() * 0xFFFFFF
			with(_graphic)
			{
				beginFill(color);
				drawCircle(this._r,this._r,this._r);
				endFill();
			}
			this._name.x = (this._r * 2 - this._name.textWidth) >>1;
			this._name.y = (this._r * 2 - this._name.textHeight) >>1;
		}
		public function getBallBitMap():BitmapData
		{
			var s:flash.display.Sprite = new flash.display.Sprite();
			// pick a color
			var color:uint = Math.random() * 0xFFFFFF;
			// set color fill
			s.graphics.beginFill(color,1);
			// radius
			var radius:uint = this._r;
			// draw circle with a specified radius
			s.graphics.drawCircle(radius,radius,radius);
			s.graphics.endFill();
			// create a BitmapData buffer
			var bmd:BitmapData = new BitmapData(radius * 2, radius * 2, true, color);
			// draw the shape on the bitmap
			bmd.draw(s);
			return bmd
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
			this._nameText = n;
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
			var e:MoveEvent = new MoveEvent("moveing");
			e.x = x;
			e.y = y;
			this.dispatchEvent(e);
		}
		
		override public function set y(value:Number):void
		{
			if(super.y == value)
				return;
			super.y = value;
			var e:MoveEvent = new MoveEvent("moveing");
			e.x = x;
			e.y = y;
			this.dispatchEvent(e);
		}
		private var _runfromstate:String;
		private var _runtween:TweenMax;
		private var _runfinish:Function;
		private var _onUpdate:Function;
		public function runTo(destPoint:Point,finish:Function = null):void
		{

			var intdestPoint:Point = new Point(int(destPoint.x),int(destPoint.y));
			
			var vecsrc:Vector2D = new Vector2D(x,y);
			var vecdest:Vector2D = new Vector2D(intdestPoint.x,intdestPoint.y);
			var distance:Number =  vecdest.dist(vecsrc);
			var time:Number = distance / speed;
			var tw:TweenMax = TweenMax.to(this,time,{x:intdestPoint.x,y:intdestPoint.y,onComplete:onTweenComplete,onUpdate:onTweenUpdate})
			var npcins:Ball = this;
			function onTweenUpdate():void
			{
				if(_onUpdate !=null)
				{
					_onUpdate(x,y);
				}
			}
			function onTweenComplete():void
			{
				
				if(_runfinish != null)
					_runfinish(npcins);
				_runfinish = null;
			};
			_runfinish = finish;
		}
		public function runToUnUpdate(destPoint:Point,finish:Function = null):void
		{
			var intdestPoint:Point = new Point(int(destPoint.x),int(destPoint.y));
			
			var vecsrc:Vector2D = new Vector2D(x,y);
			var vecdest:Vector2D = new Vector2D(intdestPoint.x,intdestPoint.y);
			var distance:Number =  vecdest.dist(vecsrc);
			var time:Number = distance / speed;
			var tw:TweenMax = TweenMax.to(this,time,{x:intdestPoint.x,y:intdestPoint.y,onComplete:onTweenComplete})
			var npcins:Ball = this;
			function onTweenComplete():void
			{
				
				if(_runfinish != null)
					_runfinish(npcins);
				_runfinish = null;
			};
			_runfinish = finish;
		}
		
		public function get speed():Number
		{
			return _speed;
		}
		public function set speed(s:Number):void
		{
			_speed = s;
		}
		
		public function set onUpdate(func:Function):void
		{
			this._onUpdate = func;
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

	}
}
package
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import gs.TweenMax;
	
	import netServer.SocketManager;
	
	public class Ball extends Sprite implements Ienterframe
	{
		private var _r:Number = 10;
		private var _id:String;
		private var _name:TextField;
		private var _nameText:String;
		private var _speed:Number = 10;
		private var _score:int = 0;
		private var _graphic:Graphics;
		private var _mx:Number;
		private var _my:Number;
		private var _isplayer:Boolean = false;
		public function Ball(id:String)
		{
			super();
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
		private var _detax:Number = 0;
		private var _detay:Number = 0;
		private var _currsync:int = 0;
		public function setDetaPos(x:Number,y:Number):void
		{
			_detax = x;
			_detay = y;
		}
		public function runTo(destPoint:Point,finish:Function = null):void
		{
			
			_mx = destPoint.x;
			_my = destPoint.y;
			if(_mx == 0 && _my == 0)
			{
				_detax = 0
				_detay = 0;
				return;
			}
			var distance:Number = Math.sqrt(_mx*_mx + _my*_my)
			var costFrame:Number = distance/speed;
			
			_detax =  _mx/costFrame;
			_detay = _my/costFrame;
			
//			var lastx:Number = parent.x + detax;
//			var lMaxx:Number = Math.min(lastx,0)
//			var lMinx:Number = Math.max(lMaxx,-(10000 - this.stage.stageWidth))
//			_detax = int(lMinx - parent.x);
//			
//			var lasty:Number = parent.y + detay;
//			var lMaxy:Number = Math.min(lasty,0)
//			var lMiny:Number = Math.max(lMaxy,-(10000 - this.stage.stageHeight))
//			_detay = int(lMiny - parent.y);
			if(_detax == 0 && _detay == 0)
			{
				return;
			}

			var param:Dictionary = new Dictionary;
			param['rid'] = id;
			param['x'] = _detax;
			param['y'] = _detay;
			SocketManager.o.callunlock2("r_sync.move",param);
		}
		
		private var _onUpdate:Function = null
		public function set onUpdate(func:Function):void
		{
			_onUpdate = func
		}
		public function update():void
		{
			if((parent.x + _detax)>0 || (parent.x + _detax) < -(10000 - this.stage.stageWidth))
			{
				
			}
			else
			{
				x -= _detax;
			}
			if((parent.y + _detay)>0 || (parent.y + _detay) < -(10000 - this.stage.stageHeight))
			{
				
			}
			else
			{
				y -= _detay;
			}
			if(_onUpdate != null)
			{
				_onUpdate(_detax,_detay)
			}
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
			if(_isplayer)
			{
				var _ins:Ball = this
				this.addEventListener(Event.ADDED_TO_STAGE,function(e:Event):void
				{
					CJPlayerSceneLayer.o().addList(_ins);
				});
				this.addEventListener(Event.REMOVED_FROM_STAGE,function(e:Event):void
				{
					CJPlayerSceneLayer.o().removeList(_ins);
				});
			}
		}


	}
}
package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import gs.TweenMax;
	
	
	/**
	 * 摄像机控制类 
	 * @author yongjun
	 * 
	 * 左上角是(0,0)点
	 * 
	 */
	public class SCamera extends Sprite
	{
		
		public function SCamera(target:DisplayObject)
		{
			super();
			_controltarget = target;
			this.addEventListener(Event.ENTER_FRAME,advanceTime);
		}
		
		/**
		 *  数据是否有效
		 */
		private var _invalidate:Boolean = true;
		
		private var _minx:Number = 0;
		private var _maxx:Number = 0;
		private var _miny:Number = 0;
		private var _maxy:Number = 0;
		
		
		private var _controltarget:DisplayObject;
		private var _autoclip:Boolean = false;

		/**
		 * auto clip show area
		 * with self clipRect.width clipRect.height 
		 */
		public function get autoclip():Boolean
		{
			return _autoclip;
		}

		/**
		 * @private
		 */
		public function set autoclip(value:Boolean):void
		{
			_autoclip = value;
		}

		
		public function advanceTime(e:Event):void
		{
			_computeView();
			
		}
		protected function invalidate():void
		{
			_invalidate = true;
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
		}
		
		
		
		
		override public function set scaleX(value:Number):void
		{
			super.scaleX = value;
			invalidate();
		}
		
		override public function set scaleY(value:Number):void
		{
			super.scaleY = value;
			invalidate();
		}
		/**
		 * 设置新的坐标 
		 * @param x
		 * @param y
		 * 
		 */
		public function moveTo(x:Number,y:Number,moveTime:Number):void
		{
			var destx:Number,desty:Number = 0;
			destx = Math.max(x,_minx);
			destx = Math.min(_maxx,destx);
			
			desty = Math.max(y,_miny);
			desty = Math.min(_maxy,desty);
			
			
			var t:TweenMax = TweenMax.to(this,moveTime,{x:destx,y:desty});
		}
		
		override public function set x(value:Number):void
		{
			value = Math.max(value,_minx);
			value = Math.min(_maxx,value);
			
			super.x = value;
			invalidate();
		}
		
		override public function set y(value:Number):void
		{
			value = Math.max(value,_miny);
			value = Math.min(_maxy,value);
			super.y = value;
			invalidate();
		}
		
	
		
		override public function set rotation(value:Number):void
		{
			super.rotation = value;
			invalidate();
		}
		
		


		public function get controltarget():DisplayObject
		{
			return _controltarget;
		}

		public function set controltarget(value:DisplayObject):void
		{
			_controltarget = value;
			invalidate();
		}
		
		private function _computeView():void
		{
			if(_controltarget == null)
				return;
			//不需要刷新
			if(!_invalidate)
			{
				return;
			}
			_invalidate = false;
			_controltarget.x = -x;
			_controltarget.y = -y;
		}

		/**
		 * x最小值 
		 */
		public function get minx():Number
		{
			return _minx;
		}

		/**
		 * @private
		 */
		public function set minx(value:Number):void
		{
			_minx = value;
		}

		/**
		 * x最大值 
		 */
		public function get maxx():Number
		{
			return _maxx;
		}

		/**
		 * @private
		 */
		public function set maxx(value:Number):void
		{
			_maxx = value;
		}

		/**
		 * y最小值 
		 */
		public function get miny():Number
		{
			return _miny;
		}

		/**
		 * @private
		 */
		public function set miny(value:Number):void
		{
			_miny = value;
		}

		/**
		 * y 最大值 
		 */
		public function get maxy():Number
		{
			return _maxy;
		}

		/**
		 * @private
		 */
		public function set maxy(value:Number):void
		{
			_maxy = value;
		}
		
		

	}
}
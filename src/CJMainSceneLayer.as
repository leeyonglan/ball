package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import netEvent.MessageEvent;
	
	import netServer.SocketManager;
	import netServer.SocketMessage;
	
	/**
	 *  主城层
	 * @author yongjun
	 * 
	 */
	public class CJMainSceneLayer extends Sprite implements Ienterframe
	{
		
		protected var _mapLayer:CJPlayerSceneLayer = null;
		protected var _rankLayer:Sprite = null;
		protected var _bgLayer:Sprite = null;
		
		private var _wn:int = 200;
		private var _hn:int = 200;
		private var _w:int = 50;
		
		private var _render:Boolean = false;
		/**
		 * 场景玩家管理器 
		 */
		protected var _sceneplayermanager:CJScenePlayerManager = null;

		
		protected var _runRange:Rectangle;
		/**
		 * 初始化主角 
		 */		
		protected var _role:Ball;
		
		public function CJMainSceneLayer()
		{
			super();
		}
		
		public function init():void
		{
			this._init();
			//初始化格子
			this._initGrid();
			//取主角数据
			_initRole();
			//初始化事件监听器
			_initEventListener();
		}
		
		private function _initEventListener():void
		{
			stage.addEventListener(Event.ENTER_FRAME,enterFameHandler);
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onSocketPlayerRank);
		}
		private function enterFameHandler(e:Event):void
		{
			this.update();
			var list:Vector.<DisplayObject> = this._mapLayer.getmChildren();
			for(var i:String in list)
			{
				if(list[i] == this._role)
				{
					continue;
				}
				(list[i] as Ball).update();
			}
		}
		
		private function _initGrid():void
		{
			for(var g:int = 0;g<4;g++)
			{
				for(var h:int = 0;h<4;h++)
				{
					var bitdata:BitmapData = new BitmapData(2500,2500);
					var s:Sprite = new Sprite();
					with(s.graphics)
					{
						lineStyle(.5,0xcccccc,.5);
						for(var j:int=0;j<=50;j++)
						{
							for(var i:int=0;i<=50;i++)
							{
								moveTo(0,i*_w)
								lineTo(50*_w,i*_w);
							}
							
							moveTo(j*_w,0);
							lineTo(j*_w,50*_w);
						}
					}
					bitdata.draw(s);
					var bitmap:Bitmap = new Bitmap(bitdata);
					bitmap.x = h*bitdata.width;
					bitmap.y = g*bitdata.height;
					_bgLayer.addChild(bitmap);
				}
			}
			_bgLayer.cacheAsBitmap = true;
		}
		
		/**
		 *  
		 * 初始化
		 */
		private function _init():void
		{
			_mapLayer = new CJPlayerSceneLayer;
			_sceneplayermanager = new CJScenePlayerManager(this.mapLayer);
			
			_bgLayer = new Sprite;

			_mapLayer.addChildAt(_bgLayer,0);
			
			stage.addEventListener(flash.events.FocusEvent.FOCUS_OUT,function(e:Event):void
			{
				_render = false;
			});
			stage.addEventListener(flash.events.FocusEvent.FOCUS_IN,function(e:Event):void
			{
				_render = true;
			});
			_mapLayer.mouseChildren = false;
			
			this.addChild(_mapLayer);
			
			_rankLayer = new Sprite;
			this.addChild(_rankLayer);
			
			
			for(var i:int=0;i<10;i++)
			{
				var tipsaccount:TextField = new TextField;
				tipsaccount.x = 430;
				tipsaccount.y = 5 +i*(20);
				tipsaccount.name = "rank"+String(i);
				tipsaccount.text = "rank"+String(i);
				//				this.addChild(tipsaccount);
			}
			
			_runRange = new Rectangle(200,200,this.stage.stageWidth - 200,this.stage.stageHeight - 200);
		}
		
		/**
		 *  地图层
		 * @return 
		 * 
		 */
		public function get mapLayer():Sprite
		{
			return _mapLayer;
		}

		private function _onSocketPlayerRank(e:MessageEvent):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.SC_SYNC_SYNCRANK)
				return;
			var params:Array = message.retparams;
		}
		
		/**
		 * 初始化其它玩家 
		 * 
		 */
		private function _initOtherPlayers():void
		{
			_sceneplayermanager.activeManager();
			_sceneplayermanager.freshAllPlayers();
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			if(_sceneplayermanager != null)
			{
				_sceneplayermanager.removeAllPlayers();
				_sceneplayermanager.deactiveManager();
				_sceneplayermanager = null;
			}
			_npcList = null;
		}

		private function _initRole():void
		{
			//初始化npc
			this._initNpc();
			
			var balldata:CJDataOfHero = CJDataOfHeroList.o().getMainHero();
			_role= new Ball(balldata.heroid);
			_role.isplayer = true;
			_role.bname = balldata.name;
			
			var originalPos:Point = CJPlayerDataManager.o().getOriginalPos(balldata.gid,balldata.x,balldata.y);
			
			_sceneplayermanager.addRole(_role,originalPos.x,originalPos.y);
			var disx:Number = originalPos.x - this.stage.stageWidth/2;
			var disy:Number = originalPos.y - this.stage.stageHeight/2;
			
			tweenMapLayer(-disx,-disy);
			_role.x = originalPos.x;
			_role.y = originalPos.y
			_role.radius = balldata.currentexp;
			_role.score = int(balldata.currentexp);
			
			//初始化其它玩家
			_initOtherPlayers();
				
		}
		
		private function tweenMapLayer(detax:Number,detay:Number):void
		{
			var detaPoint:Point = this.getLayerDetaPoint(this,detax,detay);
			detax = detaPoint.x;
			detay = detaPoint.y;
			this._mapLayer.x +=detax;
			this._mapLayer.y +=detay;
			
//			var distance:Number = Math.sqrt(detax*detax + detay*detay)
//			var time:Number = distance/1000;
//			TweenMax.to(this,time,{x:String(detax),y:String(detay),onComplete:null})
		}
		private function getLayerDetaPoint(layer:Sprite,detax:Number,detay:Number):Point
		{
			if(layer.x + detax >=0)
			{
				detax = -layer.x;
			}
			if(layer.x + detax <= -(layer.width - this.stage.stageWidth))
			{
				detax = -(layer.width - this.stage.stageWidth) - layer.x
			}
			if(layer.y + detay>=0)
			{
				detay = -layer.y
			}
			if(layer.y + detax <= -(layer.height - this.stage.stageHeight))
			{
				detay = -(layer.height - this.stage.stageHeight) - layer.y
			}
			return new Point(detax,detay);
		}
		/**
		 * 检测碰撞
		 */
		private function checkCollision(cx:Number,cy:Number):void
		{
			var param:Dictionary = new Dictionary;
			param['rid'] = _role.id;
			param['x'] = cx;
			param['y'] = cy;
			SocketManager.o.callunlock2("r_sync.move",param);
			var grid:int = CJPlayerDataManager.o().update(_role.id,cx,cy)
			var rangGrids:Array =  CJPlayerDataManager.o().getRangeGrids(grid,_role.radius);
			var checkGrids:Vector.<Cell> = CJPlayerDataManager.o().getAllInGrids(rangGrids);
			for(var i:String in checkGrids)
			{
				var c:Cell = checkGrids[i];
				var gids:Array = c.getGid();
				for(var j:String in gids)
				{
					if(gids[j] == _role.id) continue;
					var ball:Ball = _sceneplayermanager.getPlayer(gids[j]);
					if(ball != null)
					{
						var r:Boolean = CJPlayerDataManager.o().checkEat(_role,ball);
						if(r)
						{
							var param:Dictionary = new Dictionary;
							param['toguid'] = ball.id;
							SocketManager.o.callunlock2("r_sync.eat",param);
						}
					}
				}
			}
		}

		/**
		 * 初始化场景中的NPC 
		 */		
		private var _npcList:Dictionary = new Dictionary(true);
		private function _initNpc():void
		{
			var list:Dictionary = CJDataOfHeroList.o().getNpcData();
			for(var i:String in list)
			{
				if(list[i][1] == 1)
				{
					var npc:Ball = new Ball(i);
					_sceneplayermanager.addNpc(npc,int(i),list[i][2],list[i][3]);
				}
			}
		}
		private var speed:Number = 5;
		public function update():void
		{
			if(!_render)return;
			var destX:Number = -(stage.mouseX - (this.stage.stageWidth>>1));
			var destY:Number = -(stage.mouseY - (this.stage.stageHeight>>1));
			if(destX == 0 && destY == 0)
			{
				return;
			}
			var distance:Number = Math.sqrt(destX*destX + destY*destY)
			var costFrame:Number = distance/speed;
			
			
			var detax:Number =  destX/costFrame;
			var detay:Number = destY/costFrame;
			
			var lastx:Number = this._mapLayer.x + detax;
			var lMaxx:Number = Math.min(lastx,0)
			var lMinx:Number = Math.max(lMaxx,-(10000 - this.stage.stageWidth))
			detax = int(lMinx - this._mapLayer.x);
			this._role.x -= detax;   //211410.35
			this._mapLayer.x += detax;//-201908.3
			
			var lasty:Number = this._mapLayer.y + detay;
			var lMaxy:Number = Math.min(lasty,0)
			var lMiny:Number = Math.max(lMaxy,-(10000 - this.stage.stageHeight))
			detay = int(lMiny - this._mapLayer.y);
			this._role.y -= detay;
			this._mapLayer.y += detay;
			
			checkCollision(this._role.x,this._role.y)
		}

		protected function _movefinish(role:Ball):void
		{
			_role.speed = 50;
		}
		
	}
}
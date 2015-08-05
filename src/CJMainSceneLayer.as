package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import gs.TweenMax;
	
	import netEvent.MessageEvent;
	
	import netServer.SocketManager;
	import netServer.SocketMessage;
	
	/**
	 *  主城层
	 * @author yongjun
	 * 
	 */
	public class CJMainSceneLayer extends Sprite
	{
		
		protected var _mapLayer:Sprite = null;
		protected var _staticLayer:Sprite = null;
		protected var _npcLayer:Sprite = null;
		protected var _playerLayer:CJPlayerSceneLayer = null;
		protected var _rankLayer:Sprite = null;
		
		protected var _carmera:SCamera;
		
		private var _wn:int = 200;
		private var _hn:int = 200;
		private var _w:int = 50;
		
		/**
		 * 场景玩家管理器 
		 */
		protected var _sceneplayermanager:CJScenePlayerManager = null;

		protected var _runDisplayLeftWidth:int = 300;
		protected var _runDisplayRightWidth:int = 300;
		protected var _runDisplayBottomHeight:int = 300;
		protected var _runDisplayTopHeight:int = 300;
		
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
			//初始化事件监听器
			_initEventListener();
			//取主角数据
			_initRole();
		}
		
		private function _initGrid():void
		{
			var s:Sprite = new Sprite();
			with(s.graphics)
			{
				lineStyle(.5,0xFF0000,.5);
				for(var j:int=0;j<=_hn;j++)
				{
					for(var i:int=0;i<=_wn;i++)
					{
						moveTo(0,i*_w)
						lineTo(_wn*_w,i*_w);
					}
					
					moveTo(j*_w,0);
					lineTo(j*_w,_hn*_w);
				}
			}
			this._staticLayer.addChildAt(s,0);
		}
		
		/**
		 *  
		 * 初始化
		 */
		private function _init():void
		{
			_mapLayer = new Sprite;
			_staticLayer = new Sprite;
			with(_staticLayer.graphics)
			{
				beginFill(0xffffff,0.1)
				drawRect(0,0,_wn*_w,_hn*_w)
				endFill()
			}
			
			_mapLayer.mouseChildren = false;
			_mapLayer.addEventListener(MouseEvent.CLICK,_touchHandler);
			
			this.addChild(_mapLayer);
			
			_mapLayer.addChild(_staticLayer);
			
			_npcLayer = new Sprite;
			_staticLayer.addChild(_npcLayer);
			
			_playerLayer = new CJPlayerSceneLayer();
			this.addChild(_playerLayer);
			
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
		/**
		 * NPC层
		 * @return 
		 * 
		 */
		public function get npcLayer():Sprite
		{
			return this._npcLayer;
		}
		/**
		 * 玩家层 
		 */
		public function get playerLayer():Sprite
		{
			return _playerLayer;
		}
		
		private function _initEventListener():void
		{
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onSocketPlayerRank);
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
			_sceneplayermanager = new CJScenePlayerManager(this.playerLayer);
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
			var balldata:CJDataOfHero = CJDataOfHeroList.o().getMainHero();
			_role= new Ball(balldata.heroid);
//			_role.addEventListener("moveing",_roleMoveHandler);
			_role.onUpdate = this.checkCollision;
			_role.speed = 500;
			_role.bname = balldata.name;
			
			var originalPos:Point = CJPlayerDataManager.o().getOriginalPos(balldata.gid,balldata.x,balldata.y);
			
			//初始化其它玩家
			_initOtherPlayers();
			
			_sceneplayermanager.addRole(_role,originalPos.x,originalPos.y);
			
			var disx:Number = originalPos.x - this.stage.stageWidth/2;
			var disy:Number = originalPos.y - this.stage.stageHeight/2;
			
			tweenMapLayer(-disx,-disy);
			_role.bname = "wwww";
			_role.x = originalPos.x;
			_role.y = originalPos.y
			_role.radius = 20;//balldata.currentexp;
			_role.score = int(balldata.currentexp);
			//初始化npc
			this._initNpc();
			
//			var screenmidx:Number = this.stage.stageWidth>>1
//			var screenmidy:Number = this.stage.stageHeight>>1
//			
//			this.mapLayer.x -= originalPos.x - screenmidx
//			this.mapLayer.y -= originalPos.y - screenmidy
				
		}
		
		private function tweenMapLayer(detax:Number,detay:Number):void
		{
			var detaPoint:Point = this.getLayerDetaPoint(this,detax,detay);
			detax = detaPoint.x;
			detay = detaPoint.y;
			var distance:Number = Math.sqrt(detax*detax + detay*detay)
			var time:Number = distance/1000;
			TweenMax.to(this,time,{x:String(detax),y:String(detay),onComplete:null})
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
							param['touid'] = ball.id;
							SocketManager.o.callunlock2("r_sync.eat",param);
						}
					}
				}
			}
		}

		/**
		 * 主角移动 
		 * @param destPoint
		 * @param finishFunc
		 * 
		 */
		protected function _rolemoveTo(destPoint:Point,finishFunc:Function = null):void
		{
			_rolemoveToWithSendSocket(destPoint,finishFunc,true);
		}
		
		private function _rolemoveToWithSendSocket(destPoint:Point,finishFunc:Function = null,isSend:Boolean = true):void
		{
			this._role.runTo(destPoint,finishFunc);
		}

		protected function _roleMoveHandler(e:MoveEvent):void
		{
			var destx:Number = 0.0;
			var desty:Number = 0.0;
			if (e.x >_carmera.x+(this.stage.stageWidth - _runDisplayRightWidth) ||
				e.y >_carmera.y+(this.stage.stageHeight - _runDisplayBottomHeight)
			)
			{
				destx = e.x - (this.stage.stageWidth - _runDisplayRightWidth);
				desty = e.y - (this.stage.stageHeight - _runDisplayBottomHeight);
				_carmera.moveTo(destx,desty,0.1);
			}
			else if (e.x < _carmera.x + _runDisplayLeftWidth || e.y < _carmera.y + _runDisplayTopHeight)
			{
				destx = e.x - _runDisplayLeftWidth;
				desty = e.y - _runDisplayTopHeight;
			}
			
			if(destx != 0 || desty != 0)
			{
				var distancex:Number = Math.abs(_carmera.x - destx);
				var distancey:Number = Math.abs(_carmera.y - desty);
				var distance:Number = Math.sqrt(distancex * distancex + distancey * distancey);
				_carmera.moveTo(destx,desty,distance/_role.speed);
			}
		}		
//		protected function _roleMoveHandler(e:MoveEvent):void
//		{
//			var destx:Number = e.x;
//			var desty:Number = e.y;
//			if(_carmera.x >= this._mapLayer.width - this.stage.stageWidth)
//			{
//				destx = this._mapLayer.width - this.stage.stageWidth
//			}
//			
//			if(_carmera.y >= this._mapLayer.height - this.stage.stageHeight)
//			{
//				desty = this._mapLayer.height - this.stage.stageHeight
//			}
//			if(_carmera.x <= 0)
//			{
//				destx = 0
//			}
//			if(_carmera.y <= 0)
//			{
//				desty = 0;
//			}
//			
//			var distancex:Number = Math.abs(_carmera.x - destx);
//			var distancey:Number = Math.abs(_carmera.y - desty);
//			var distance:Number = Math.sqrt(distancex * distancex + distancey * distancey);
//			_carmera.moveTo(destx,desty,distance/_role.speed);
//		}
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
					this._npcLayer.addChild(npc);
				}
			}
		}

		protected function _touchHandler(e:MouseEvent):void
		{
			var destX:Number = -(e.stageX - (this.stage.stageWidth>>1));
			var destY:Number = -(e.stageY - (this.stage.stageHeight>>1));
			var detaPoint:Point = this.getLayerDetaPoint(this._mapLayer,destX,destY);
			var distance:Number = Math.sqrt(detaPoint.x*detaPoint.x + detaPoint.y*detaPoint.y);
			var time:Number = distance/_role.speed;
			TweenMax.to(this._mapLayer,time,{x:String(detaPoint.x),y:String(detaPoint.y)})
				
//			TweenMax.to(this._mapLayer,time,{x:10,y:20})
				
//			var destpoint:Point = _mapLayer.globalToLocal(new Point(e.localX,e.localX));
//			_rolemoveTo(destpoint,_movefinish);
		}
		
		/**
		 * 检测是否进入传送点 
		 * @param role
		 * 
		 */
		protected function _movefinish(role:Ball):void
		{
			_role.speed = 50;
		}
		
	}
}
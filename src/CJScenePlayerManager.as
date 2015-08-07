package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import netEvent.MessageEvent;
	
	import netServer.SocketManager;
	import netServer.SocketMessage;

	/**
	 * 玩家管理器 
	 * @author yongjun
	 * 
	 */
	public class CJScenePlayerManager
	{
		public function CJScenePlayerManager(playerLayer:Sprite)
		{
			_playerLayer = playerLayer;
		}
		
		private var _isActive:Boolean = false;
	
		private var _playerLayer:Sprite;
		private var _currentPlayersCount:uint = 0;
		/**
		 * 最大xianshishuliang 
		 */
		private static const MAX_DISPLAY_COUNT:uint = 10;
		
		
		private var _dictOfOtherPlayers:Dictionary = new Dictionary();
		/**
		 * 刷新所有的玩家 
		 * 
		 */
		public function freshAllPlayers():void
		{
			var heroList:CJDataOfHeroList =CJDataOfHeroList.o();
			var playersDict:Dictionary = heroList.getOtherPlayerData();
			for(var i:String in playersDict)
			{
				_addPlayer(playersDict[i]);
			}
		}
		
		public function getPlayer(uid:String):Ball
		{
			if(!_dictOfOtherPlayers.hasOwnProperty(uid))
			{
				return null;
			}
			else
			{
				var data:Ball = _dictOfOtherPlayers[uid];
				return data;
			}
		}
		
		/**
		 * 激活管理器 
		 * 
		 */
		public function activeManager():void
		{
			if(_isActive){
				return;
			}
			_isActive = true;
			SocketManager.o.addEventListener(SocketManager.MESSAGERECEIVE,_onSocketPlayerAppear);
			SocketManager.o.addEventListener(SocketManager.MESSAGERECEIVE,_onSocketPlayerDisAppear);
			SocketManager.o.addEventListener(SocketManager.MESSAGERECEIVE,_onSocketPlayerMoveTo);
			SocketManager.o.addEventListener(SocketManager.MESSAGERECEIVE,_onSocketPlayerFail);
			SocketManager.o.addEventListener(SocketManager.MESSAGERECEIVE,_onSocketPlayerStatus);
			SocketManager.o.addEventListener(SocketManager.MESSAGERECEIVE,_onSocketRefreshNpc);
		}
		
		
		
		public function deactiveManager():void
		{
			if(!_isActive){
				return;
			}
			_isActive = false;
			SocketManager.o.removeEventListener(SocketManager.MESSAGERECEIVE,_onSocketPlayerAppear);
			SocketManager.o.removeEventListener(SocketManager.MESSAGERECEIVE,_onSocketPlayerDisAppear);
			SocketManager.o.removeEventListener(SocketManager.MESSAGERECEIVE,_onSocketPlayerMoveTo);
			SocketManager.o.removeEventListener(SocketManager.MESSAGERECEIVE,_onSocketPlayerFail);
			SocketManager.o.removeEventListener(SocketManager.MESSAGERECEIVE,_onSocketPlayerStatus);
			SocketManager.o.addEventListener(SocketManager.MESSAGERECEIVE,_onSocketRefreshNpc);
			
		}
		
		

		
		private function _onSocketRefreshNpc(e:MessageEvent):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.SC_SYNC_REFRESHNPC)
				return;
			var params:Array = message.retparams;
			for(var i:String in params)
			{
				var id:String = params[i][0];
				var visible:int = params[i][1];
				if(visible == 1)
				{
					this._refreshPlayer(id,params[i][2],params[i][3]);
				}
			}
		}
		/**
		 * 玩家出现 
		 * @param e
		 * 
		 */
		private function _onSocketPlayerAppear(e:MessageEvent):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.SC_SYNC_SYNCAPPEAR)
				return;
			var params:Array = message.retparams;
			_addPlayer(params);
			
		}
		private function _onSocketPlayerDisAppear(e:MessageEvent):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.SC_SYNC_SYNDISAPPEAR)
				return;
			var params:Array = message.retparams;
			var i:uint,length:uint;
			length = params.length;
			for (i=0;i<length;i++)
			{
				_removePlayer(params[i]);
			}
		}
		private function _onSocketPlayerMoveTo(e:MessageEvent):void
		{			
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.SC_SYNC_SYNCMOVETO)
				return;
			var params:Array = message.retparams;
			var uid:String = params[1];
			var x:int = parseInt(params[2]);
			var y:int = parseInt(params[3]);
			
			var destplayer:Ball = getPlayer(uid);
			if(destplayer != null)
			{
				destplayer.runTo(new Point(x,y));
				CJPlayerDataManager.o().update(uid,x,y)
			}
		}
		
		private function _onSocketPlayerFail(e:MessageEvent):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.SC_SYNC_Fail)
				return;
			
		}
		
		private function _onSocketPlayerStatus(e:MessageEvent):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.SC_SYNC_Status)
				return;
			var params:Object = message.retparams;
			var failUid:String = params['fail'];
			var succUid:String = params['succ'][0];
			var sore:Number = params['succ'][1];
			var detasocre:Number = params['succ'][2];
			_removePlayer(failUid);
			CJPlayerDataManager.o().remove(failUid);
			var ball:Ball = this.getPlayer(succUid);
			ball.toBigger(detasocre);
		}
		/**
		 * 
		 * @param playerinfos 远程返回的用户信息[uid,x,y,level]
		 * 
		 */
		private function _addPlayer(playerinfos:Array):void
		{
			var id:String = playerinfos[0];
			var name:String = playerinfos[1];
			var score:int = playerinfos[2];
			var grid:int = playerinfos[3];
			var x:Number = playerinfos[4];
			var y:Number = playerinfos[5];
			
			if(!_dictOfOtherPlayers.hasOwnProperty(id))
			{
				_currentPlayersCount ++;
				
				var player:Ball = new Ball(id);
				player.isplayer = true;
				player.name = "PC_" + id;
				player.bname = name;
				
				_dictOfOtherPlayers[id] = player;
				if(_dictOfOtherPlayers.hasOwnProperty(id) && _playerLayer.getChildByName("PC_" + id) == null)
				{
					var originalPos:Point = CJPlayerDataManager.o().getOriginalPos(grid,x,y);
					_playerLayer.addChild(player);
					player.radius = score;
					CJPlayerDataManager.o().update(id,originalPos.x,originalPos.y)
					player.setToPosition(new Point(originalPos.x,originalPos.y));
				}
			}
		}
		
		public function addNpc(p:Ball,id:int,x:Number,y:Number):void
		{
			if(!_dictOfOtherPlayers.hasOwnProperty(p.id) && _playerLayer.getChildByName("PC_" + p.id) == null)
			{
				var originalPos:Point = CJPlayerDataManager.o().getOriginalPos(id,x,y);
				_dictOfOtherPlayers[p.id] = p;
				
				_playerLayer.addChild(p);
				p.name = "PC_" + p.id;
				p.x = originalPos.x;
				p.y = originalPos.y;
				CJPlayerDataManager.o().update(String(id),p.x,p.y);
			}
		}
		
		public function addRole(role:Ball,x:Number,y:Number):void
		{
			_dictOfOtherPlayers[role.id] = role;
			role.name = "PC_" + role.id;
			_playerLayer.addChild(role);
//			role.setToPosition(new Point(x,y));
			CJPlayerDataManager.o().update(role.id,x,y)
		}
		
		/**
		 * 删除玩家 
		 * @param uid
		 * 
		 */
		public function _removePlayer(uid:String):void
		{
			if(_dictOfOtherPlayers.hasOwnProperty(uid))
			{
				_currentPlayersCount --;
				var removeBall:Ball = (_dictOfOtherPlayers[uid] as Ball)
				_playerLayer.removeChild(removeBall);
				delete _dictOfOtherPlayers[uid];
			}
		}
		
		public function _refreshPlayer(uid:String,x:Number,y:Number):void
		{
			if(!_dictOfOtherPlayers.hasOwnProperty(uid))
			{
				var b:Ball = _playerLayer.getChildByName("PC_" + uid) as Ball;
				if(b != null)
				{
					b.visible = true;
				}
				else
				{
					var nb:Ball = new Ball(uid);
					this.addNpc(nb,int(uid),x,y);
				}
			}		
		}
		
		public function removeAllPlayers():void
		{
		}


	}
	
	
}

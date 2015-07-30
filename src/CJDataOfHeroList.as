package
{
	import flash.utils.Dictionary;
	

	public class CJDataOfHeroList
	{
		private var _mainHeroInfo:CJDataOfHero;
		private var _npcDict:Dictionary = new Dictionary;
		private var _otherPlayers:Dictionary = new Dictionary;
		private static var _o:CJDataOfHeroList = null;
		
		public function CJDataOfHeroList()
		{
		}
		
		public static function o():CJDataOfHeroList
		{
			if(_o == null)
			{
				_o = new CJDataOfHeroList
			}
			return _o;
		}
		
		public function init():void
		{
		}
		
		public function _initHeroList( obj:Object ):void
		{
			for(var k:String in obj["npc"])
			{
				this._npcDict[obj["npc"][k][0]] = obj["npc"][k];
			}
			
			for (var key:String in obj["players"])
			{
				this._otherPlayers[obj["players"][key][0]] = obj["players"][key];
			}
			var mainInfo:CJDataOfHero = new CJDataOfHero;
			mainInfo.heroid = obj['self'][0];
			mainInfo.name = obj['self'][1];
			mainInfo.currentexp = obj['self'][2];
			mainInfo.gid = obj['self'][3];
			mainInfo.x = obj['self'][4];
			mainInfo.y = obj['self'][5];
			this._mainHeroInfo = mainInfo;
		}
		public function getNpcData():Dictionary
		{
			return this._npcDict;
		}
		public function getOtherPlayerData():Dictionary
		{
			return this._otherPlayers;
		}
		
		public function getMainHero():CJDataOfHero
		{
			return _mainHeroInfo;
		}


	}
}
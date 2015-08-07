package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import netEvent.MessageEvent;
	
	import netServer.SSocketMessage;
	import netServer.SocketManager;
	
	public class game extends Sprite
	{
		
		private var _loginLayer:login;
		private function _initServer():void
		{
			SocketManager.o.connect("115.28.180.254",9003);
			SocketManager.o.addEventListener(SocketManager.MESSAGERECEIVE,loginRet);
		}
		
		private function _initui():void
		{
			_loginLayer = new login;
			this.addChild(_loginLayer);
		}
		
		public function game()
		{
			stage.frameRate = 30;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT
			_initServer();
			_initui();
		}
		
		private function loginRet(e:MessageEvent):void
		{
			var data:SSocketMessage = e.data as SSocketMessage;
			if(data.getCommand() == "r_sync.init")
			{
				CJDataOfHeroList.o()._initHeroList(data.retparams);
				this.removeChild(_loginLayer);
				var mainLayer:CJMainSceneLayer = new CJMainSceneLayer;
				this.addChild(mainLayer);
				mainLayer.init();
			}
		}
	}
}